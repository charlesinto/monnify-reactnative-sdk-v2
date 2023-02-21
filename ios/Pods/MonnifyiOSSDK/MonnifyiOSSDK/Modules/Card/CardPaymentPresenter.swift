//
//  CardPaymentPresenter.swift
//  Monnify
//
//  Created by Kanyinsola on 11/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol CardPaymentPresenterProtocol : BasePresenter {
    
    func getCardRequirements(request: CardRequirementRequest)
    
    func payWithCard(cardNumber: String,
                     expiryDate: String,
                     cvv: String,
                     pin: String,
                     shouldShowErrorMessage: Bool,
                     fee: String,
                     totalPayable: String)
}

class CardPaymentPresenter : CardPaymentPresenterProtocol {
    
    private weak var view: CardPaymentViewDelegate?
    private let apiService: ApiServiceProtocol
    
    private var cardRequiresPin: Bool? = nil
    
    required init(view: CardPaymentViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
    }
    
    func getCardRequirements(request: CardRequirementRequest) {
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
        apiService.getCardRequirements(request: request) { [weak self] (response,_) in
            
            guard let self = self else { return }

            self.view?.dismissLoading()
            
            guard let response = response else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: StringLiterals.GenericNetworkError)
                return
            }
            
            guard response.isSuccessful, let requirePin = response.responseBody?.requirePin else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: response.responseMessage
                                            ?? "An unexpected error occurred please contact support.")
                return
            }
            
            Logger.log("cardRequiresPin \(requirePin)")
            
            self.cardRequiresPin = requirePin
            
            if requirePin {
                self.view?.showPinView()
            }
        }
    }
    
    func payWithCard(cardNumber: String,
                     expiryDate: String,
                     cvv: String, pin: String,
                     shouldShowErrorMessage: Bool,
                     fee: String,
                     totalPayable: String) {
        
        let monnify = Monnify.shared
        
        if !isInputValid(cvv, cardNumber, expiryDate, pin) {
            
            if shouldShowErrorMessage {
                self.view?.showAlertDialog(title: "Invalid Input",
                                           message: "Please ensure you completed all fields and that the card credentials entered are valid.")
            }
            
            return
        }
        
        let expiryDateMonthYearPair = CardValidator.shared.getCardExpiryDate(fromExpiryDate: expiryDate)
        
        let transactionReference = monnify.transactionResult.transactionReference
        let card = Card(number: cardNumber,
                        cvv: cvv,
                        expiryMonth: expiryDateMonthYearPair.0,
                        expiryYear: expiryDateMonthYearPair.1,
                        pin: pin)
        
        let request = CardPaymentRequest(transactionReference: transactionReference,
                                         apiKey: monnify.getApiKey(),
                                         card: card)
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
        apiService.payWithCard(request: request) { [weak self] (response, _) in
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
            
            self.handleCardPaymentResponse(cardResponse, fee, totalPayable)
        }
    }
    
    private func handleCardPaymentResponse(_ response: CardPaymentResponseBody,
                                        _ fee: String,
                                        _ totalPayable: String) {
        
        guard let cardStatus = response.status else {
          self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                     message: "An unexpected error occurred, please contact support.")
            return
        }
        
        switch cardStatus {
        case .success, .pending, .failed, .authenticationFailed:
            // Verify transaction status.
            verifyTransactionStatus(transactionReference: response.transactionReference)
        case .pinRequired:
            self.view?.showPinView()
        case .otpAuthorizationRequired:
            let enterOtpViewModel = createOTPViewModel(metaData: Monnify.shared.metadata,
                                                       tokenData: response.tokenData,
                                                       fee: fee,
                                                       totalPayable: totalPayable)
            
            self.view?.openEnterOTPViewController(viewModel: enterOtpViewModel)
        case .bankAuthorizationRequired:
            self.view?.open3DSAuthWebView(secure3dData: response.secure3dData)
        }
    }
    
    private func createOTPViewModel(metaData: TransactionMetaData,
                                tokenData: TokenData,
                                fee: String,
                                totalPayable: String) -> EnterOTPViewModel {
        
        return EnterOTPViewModel(
            tokenData: tokenData,
            providerReference: nil,
            paymentMethod: .card,
            merchantName: metaData.merchantName,
            customerEmail: metaData.customerEmail,
            merchantLogoUrl: metaData.merchantLogoUrl,
            totalPayable: totalPayable,
            totalPayableAmount: 0.00,
            itemValue: 0.00.commaSeparatedNairaValue(currencyCode: metaData.currencyCode),
            fee: fee)
        
    }
    
    private func verifyTransactionStatus(transactionReference: String) {
        
        let monnify = Monnify.shared
        let metadata = monnify.metadata!

        let apiKey = monnify.getApiKey() ?? ""
        let transactionReference = monnify.transactionResult.transactionReference
        
        view?.showLoading(text: StringLiterals.VerifyingTransactionStatus)
        
        apiService.checkTransactionStatus(apiKey: apiKey,
                                          transactionReference: transactionReference) { [weak self] (response, error) in
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
                                            ?? "An unexpected error occurred please try again.")
                return
            }
            
            let transactionStatusViewModel = TransactionStatusViewModel.create(transaction, metadata)
                                            
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
        
        Logger.log("Result after \(transactionResult)")
    }

    private func isInputValid(_ cvv: String,
                              _ cardNumber: String,
                              _ expiryDate: String,
                              _ pin: String) -> Bool {
                
        if !isCardEntryStateValid(cvv, cardNumber, expiryDate) {
            self.view?.showAlertDialog(title: StringLiterals.InvalidInput,
                                       message: StringLiterals.InvalidCardEntry)
            return false
        }
        
        if cardRequiresPin != false && pin.count < 4 {
            
            self.view?.showAlertDialog(title: StringLiterals.InvalidInput,
                                       message: StringLiterals.InvalidCardPinMessage)
            return false
        }
        
        let expiryDateMonthYearPair = CardValidator.shared.getCardExpiryDate(fromExpiryDate: expiryDate)
        
        if expiryDateMonthYearPair.0 == -1 && expiryDateMonthYearPair.1 == -1 {
            self.view?.showAlertDialog(title: StringLiterals.InvalidInput,
                                       message: StringLiterals.InvalidExpiryDate)
            return false
        }
        
        return true
    }
    
    private func isCardEntryStateValid(_ cvv: String,
                                       _ cardNumber: String,
                                       _ expiryDate: String) -> Bool {
        
        if cvv.count != 3 {
            return false
        }
        
        let cardNumberState = CardValidator.shared.validationState(forCardWithNumber: cardNumber)
        let expiryState = CardValidator.shared.validationState(forExpiryDate: expiryDate)
        let cvvState = CardValidator.shared.validationState(forCvv: cvv)
        
        Logger.log("isInputValid was called \(cvv):\(cvvState) \(cardNumber):\(cardNumberState) \(expiryDate):\(expiryState)")
        
        return cardNumberState == .valid && expiryState == .valid && cvvState == .valid
    }
    
}
