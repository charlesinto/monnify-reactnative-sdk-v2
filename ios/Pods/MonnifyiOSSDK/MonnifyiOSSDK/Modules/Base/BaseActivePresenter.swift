//
//  BaseActivePresenter.swift
//  Monnify
//
//  Created by Kanyinsola on 14/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import SwiftyJSON
import StompClientLib

protocol BaseActivePresenterProtocol: BasePresenter {
    
    func startListening()
    
    func stopListening()
}

class BaseActivePresenter: BaseActivePresenterProtocol {
    
    // TODO: When web socket issue is fixed default isPollingEnabled enabled and forcePollingEnabled to false.
    private var forcePollingEnabled = true
    private var isPollingEnabled = true
    
    private var pollingRequestCount : Int = 0
    private let pollingInterval : TimeInterval = 10.0
    private var pollingTimer : Timer?
    private var stompSocketClient: StompClientLib
    private let apiService: ApiServiceProtocol
    private weak var view: BaseActiveViewDelegate?
    
    internal var doActiveStatusRequestExists = false
    internal var isTransactionComplete = false
    
    init(view: BaseActiveViewDelegate,
         apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
        
        stompSocketClient = StompClientLib()
        stompSocketClient.certificateCheckEnabled = false
    }
    
    private func connectSocketStompClientLib() {
        
        Logger.log("connectSocket was called")
        
        guard let connectionURL = NSURL(string: ApiEndPoints.shared.socketConnection()) else {
            Logger.log("Something weird happened, url didn't resolve.")
            return
        }
        
        let request = NSURLRequest(url: connectionURL as URL)
        
        stompSocketClient.openSocketWithURLRequest(request: request,
                                                   delegate: self,
                                                   connectionHeaders: ["accept-version": "1.1,1.2",
                                                                       "heart-beat": "10000,10000"])
        
        Logger.log("Socket Connected: \(stompSocketClient.isConnected())")
    }
    
    private func subscribeToTransactionReference(transactionRef: String, stompClientLib: StompClientLib) {
        stompClientLib.subscribe(destination: ApiEndPoints.shared.transactionSubscription(transactionRef: transactionRef))
    }
    
    @objc private func timerFired() {
        
        Logger.log("POLLING TIMER FIRED")
        
        if !isPollingEnabled || isTransactionComplete {
            stopTimer()
            return
        }
        
        if doActiveStatusRequestExists {
            return
        }
        
        pollingRequestCount += 1
        verifyTransactionStatus { [weak self] transaction in
                        
            guard let self = self else { return }

            self.handleResponse(transaction, Monnify.shared.metadata, false)
            
             // always attempt to connect to socket, during polling if forced polling is not enabled
            if !self.isTransactionComplete && !self.forcePollingEnabled {
                self.connectSocketStompClientLib()
            }
        }
    }
    
    private func startPolling() {
        isPollingEnabled = true
        pollingTimer = Timer.scheduledTimer(timeInterval: pollingInterval,
                                            target: self,
                                            selector: #selector(timerFired),
                                            userInfo: nil, repeats: true)
        pollingTimer?.fire()
    }
    
    private func endPolling() {
        isPollingEnabled = false
        stopTimer()
    }
    
    private func stopTimer() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
    func startListening() {
        if isPollingEnabled {
            startPolling()
        } else {
            connectSocketStompClientLib()
        }
    }
    
    func stopListening() {
        
        isTransactionComplete = true
        
        if isPollingEnabled {
            pollingRequestCount = 0
            stopTimer()
        } else {
            if stompSocketClient.isConnected() {
                stompSocketClient.disconnect()
            }
        }
    }
    
    func verifyTransactionStatus(completion: @escaping (_ transaction: TransactionStatusResponseBody) -> Void) {
        
        let monnify = Monnify.shared
        
        let apiKey = monnify.getApiKey() ?? ""
        let transactionReference = monnify.transactionResult.transactionReference 
        
        doActiveStatusRequestExists = true
        apiService.checkTransactionStatus(apiKey: apiKey,
                                          transactionReference: transactionReference) { [weak self] (response, _) in
                                            
                guard let self = self else { return }

                self.doActiveStatusRequestExists = false
                                            
                guard let response = response else {
                    return
                }
                
                guard response.isSuccessful, let transaction = response.responseBody else {
                    return
                }
                
                self.updateMonnifyTransactionResult(transaction)
                completion(transaction)
        }
    }
    
    func handleResponse(_ transaction: TransactionStatusResponseBody,
                        _ metadata: TransactionMetaData,
                        _ shouldTerminate: Bool) { 
        
        guard let transactionStatus = TransactionStatus(rawValue: transaction.paymentStatus) else {
            return
        }
        
        if shouldTerminate || transactionStatus != .pending {
            
            isTransactionComplete = true
            
            stopListening()
            
            let transactionStatusViewModel = TransactionStatusViewModel.create(transaction,
                                                                               metadata)
            self.view?.showTransactionStatus(viewModel: transactionStatusViewModel)
        }
    }
    
    func updateMonnifyTransactionResult(_ transaction: TransactionStatusResponseBody) {
        
        let monnify = Monnify.shared
        var transactionResult = monnify.transactionResult

        Logger.log("Result before \(transactionResult)")

        let transactionStatus = TransactionStatus(rawValue: transaction.paymentStatus )
        transactionResult.transactionReference = transaction.transactionReference
        transactionResult.amountPaid = transaction.amountPaid
        transactionResult.amountPayable = transaction.payableAmount
        transactionResult.transactionStatus = transactionStatus ?? .cancelled
        transactionResult.paymentMethod = PaymentMethod(rawValue: transaction.paymentMethod )
        transactionResult.paymentReference = transaction.paymentReference
        
        Logger.log("Result before \(transactionResult)")

        withUnsafePointer(to: &transactionResult) { kkk in
            Logger.log(String(format: "%p", kkk))
        }
        
        monnify.transactionResult = transactionResult
        
        
    }
    
}

extension BaseActivePresenter : StompClientLibDelegate {
    
    func stompClient(client: StompClientLib!,
                     didReceiveMessageWithJSONBody jsonBody: AnyObject?,
                     akaStringBody stringBody: String?,
                     withHeader header: [String : String]?,
                     withDestination destination: String) {
        
        isTransactionComplete = true
        verifyTransactionStatus { [weak self] (response) in
            
            guard let self = self else { return }

            self.handleResponse(response, Monnify.shared.metadata, true)
        }
        
        Logger.log("Destination : \(destination)")
        Logger.log("JSON BODY \(String(describing: jsonBody))")
        Logger.log("String Body : \(stringBody ?? "")")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        Logger.log("Socket is Disconnected")
        if !isPollingEnabled && !isTransactionComplete {
            startPolling()
        }
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        Logger.log("Socket is connected")
        
        let transactionReference = Monnify.shared.transactionResult.transactionReference 
        subscribeToTransactionReference(transactionRef: transactionReference, stompClientLib: client)
        
        if isPollingEnabled {
            endPolling()
        }
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        Logger.log("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        Logger.log("Error Send : \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        Logger.log("Server Ping")
    }
}
