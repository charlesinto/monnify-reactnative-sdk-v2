//
//  EnterOTPPresenter.swift
//  Monnify
//
//  Created by Kanyinsola on 13/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol EnterOTPPresenterProtocol : BasePresenter {
    func authorizeCardTransaction(withOTP otp: String, _ tokenId: String)
    
    func authorizeBankTransaction(withOTP otp: String)
}

class EnterOTPPresenter: EnterOTPPresenterProtocol  {
    
    private weak var view: EnterOTPViewDelegate?
    private let apiService: ApiServiceProtocol
    private var cardRequiresPin = false
    
    required init(view: EnterOTPViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
    }
    
    func authorizeCardTransaction(withOTP otp: String, _ tokenId: String) {
        
        let monnify = Monnify.shared
        let transactionReference = monnify.transactionResult.transactionReference
        
        let request = AuthorizeCardOtpRequest(transactionReference: transactionReference,
                                              apiKey: monnify.getApiKey(),
                                              token: otp,
                                              tokenId: tokenId)
        
        if otp.count == 0 {
            self.view?.showAlertDialog(title: StringLiterals.InvalidInput,
                                       message: StringLiterals.OTPCannotBeEmptyMessage)
            return
        }
        
        view?.showLoading(text: StringLiterals.VerifyingOTP)

        apiService.authorizeCardOtp(request: request) { [weak self] (response,_) in
            
            guard let self = self else { return }
            
            self.view?.dismissLoading()
            
            guard let response = response else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: StringLiterals.GenericNetworkError)
                return
            }
            
            guard response.isSuccessful, let cardResponse = response.responseBody else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: response.responseMessage
                                            ?? "An unexpected error occurred please contact support.")
                return
            }
            
            Logger.log(" Card Response \(cardResponse)")
            self.handleCardPaymentResponse(cardResponse)
        }
    }
    
    func authorizeBankTransaction(withOTP otp: String) {
        
        let monnify = Monnify.shared
        let transactionReference = monnify.transactionResult.transactionReference
        
        let viewModel = self.view!.getViewModel()
        
        let request = AuthorizeBankOtpRequest(transactionReference: transactionReference,
                                              providerReference: viewModel.providerReference ?? "",
                                              apiKey: monnify.getApiKey()!,
                                              token: otp)
        
        if otp.count == 0 {
            self.view?.showAlertDialog(title: StringLiterals.InvalidInput,
                                       message: StringLiterals.OTPCannotBeEmptyMessage)
            return
        }
        
        view?.showLoading(text: StringLiterals.VerifyingOTP)

        apiService.authorizeBankOTP(request: request) { [weak self] (response,_) in
            
            guard let self = self else { return }
            
            self.view?.dismissLoading()
            
            guard let response = response else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: StringLiterals.GenericNetworkError)
                return
            }
            
            guard response.isSuccessful, let bankResponse = response.responseBody else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: response.responseMessage
                                            ?? "An unexpected error occurred please contact support.")
                return
            }
            
            Logger.log(" Bank Response \(bankResponse)")
            self.handleBankPaymentResponse(bankResponse)
        }
    }
    
    private func handleBankPaymentResponse(_ response: AuthorizeBankOTPResponseBody) {
        
        guard let bankStatus = response.status else {
          self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                     message: "An unexpected error occurred, please contact support.")
            return
        }
        
        switch bankStatus {
        case .success, .pending:
            // Verify transaction status.
            verifyTransactionStatus(transactionReference: response.transactionReference)
        case .failed:
            verifyTransactionStatus(transactionReference: response.transactionReference, otpFailure: true)

        }
    }
    
    
    private func handleCardPaymentResponse(_ response: CardPaymentResponseBody) {
        
        guard let cardStatus = response.status else {
          self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                     message: "An unexpected error occurred, please contact support.")
            return
        }
        
        switch cardStatus {
        case .success, .pending, .failed:
            // Verify transaction status.
            verifyTransactionStatus(transactionReference: response.transactionReference)
        case .bankAuthorizationRequired:
            self.view?.open3DSAuthWebView(secure3dData: response.secure3dData)
        case .authenticationFailed:
            self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                       message: StringLiterals.ValidatingOTPErrorMsg)
        default:
            verifyTransactionStatus(transactionReference: response.transactionReference)
        }
    }
    
    private func verifyTransactionStatus(transactionReference: String, otpFailure: Bool = false) {
        
        let monnify = Monnify.shared
        let metadata = monnify.metadata!
        
        let apiKey = monnify.getApiKey() ?? ""
        let transactionReference = monnify.transactionResult.transactionReference
        
        view?.showLoading(text: StringLiterals.VerifyingTransactionStatus)
        
        apiService.checkTransactionStatus(apiKey: apiKey,
                                          transactionReference: transactionReference) { [weak self] (response,_) in
                                            
            guard let self = self else { return }
                                            
            self.view?.dismissLoading()

            guard let response = response else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: StringLiterals.GenericNetworkError)
                return
            }
            
            guard response.isSuccessful, let transaction = response.responseBody else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: response.responseMessage
                                            ?? "An unexpected error occurred please contact support.")
                return
            }
            
            let transactionStatusViewModel = TransactionStatusViewModel.create(transaction,
                                                                               metadata, otpFailure: otpFailure)
                                            
            self.updateMonnifyTransactionResult(transaction)
            self.view?.showTransactionStatus(viewModel: transactionStatusViewModel)
        }
    }
    
    private func updateMonnifyTransactionResult(_ transaction: TransactionStatusResponseBody) {
        
        let monnify = Monnify.shared
        let transactionResult = monnify.transactionResult
        
        Logger.log("Result before \(transactionResult)")
        
        let transactionStatus = TransactionStatus(rawValue: transaction.paymentStatus )
        
        transactionResult.transactionReference = transaction.transactionReference
        transactionResult.amountPaid = transaction.amountPaid
        transactionResult.amountPayable = transaction.payableAmount
        transactionResult.transactionStatus = transactionStatus ?? .cancelled
        transactionResult.paymentMethod = PaymentMethod(rawValue: transaction.paymentMethod )
        
        Logger.log("Result before \(transactionResult)")
    }
}
