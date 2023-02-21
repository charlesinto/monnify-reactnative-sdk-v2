//
//  InitializeTransactionPresenter.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol InitializeTransactionPresenterProtocol: BasePresenter {
    
    func initializeTransaction()
}

class InitializeTransactionPresenter: InitializeTransactionPresenterProtocol {
    
    private weak var view: InitializeTransactionViewDelegate?
    private let apiService: ApiServiceProtocol
    
    required init(view: InitializeTransactionViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
    }
    
    func initializeTransaction() {
        
        let request = initializeTransactionRequest()
        
        self.view?.showLoading(text: StringLiterals.InitializingTransaction)
        
        apiService.initializeTransaction(request: request) { [weak self] (response, error) in
            
            guard let self = self else { return }
            
            self.view?.dismissLoading()
            
            guard let response = response else {
                
                Logger.log("initializeTransaction ERROR, \(error?.localizedDescription ?? "")")
                
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: StringLiterals.GenericNetworkError)
                return
            }
            
            guard response.isSuccessful, let transaction = response.responseBody else {
                self.view?.showAlertDialog(title: "", message: response.responseMessage ?? "")
                return
            }
            
            var paymentMethods = [PaymentMethod]()
            
            transaction.enabledPaymentMethod.forEach({ (string) in
                if let method = PaymentMethod(rawValue: string) {
                    paymentMethods.append(method)
                }
            })
            
            // MARK: TODO Delete next line before next release
//            paymentMethods.removeLast()
            
            if paymentMethods.isEmpty {
                self.view?.showEmptyView()
            } else {
                let currencyCode = Monnify.shared.getTransactionParameters().currencyCode
                
                let parameters = Monnify.shared.getTransactionParameters()
                let amount = parameters.amount
                let totalPayable = amount.commaSeparatedNairaValue(currencyCode: currencyCode)

                self.updateInitializedTransactionState(transaction)
                self.setTransactionMetaData(transaction: transaction,
                                            customerEmail: parameters.customerEmail,
                                            currencyCode: currencyCode,
                                            paymentMethods: paymentMethods)
                
                let viewModel = PaymentMethodListViewModel(paymentMethods: paymentMethods,
                                                           transactionReference: transaction.transactionReference,
                                                           totalPayable: totalPayable,
                                                           merchantName: transaction.merchantName,
                                                           customerEmail: parameters.customerEmail,
                                                           merchantLogoUrl: transaction.merchantLogoUrl)
                
                self.view?.showPaymentMethods(viewModel: viewModel)
            }
        }
    }
    
    private func initializeTransactionRequest() -> InitializeTransactionRequest {
        
        let monnify = Monnify.shared
        let parameter = monnify.getTransactionParameters()
        
        let request = parameter.toInitializeTransactionRequest(
            contractCode: monnify.getContractCode(),
            apiKey: monnify.getApiKey())
        
        return request
    }
    
    private func updateInitializedTransactionState(_ transaction: InitializeTransactionResponseBody) {
        Monnify.shared.transactionResult.transactionReference = transaction.transactionReference
    }
    
    private func setTransactionMetaData(transaction: InitializeTransactionResponseBody,
                                        customerEmail: String,
                                        currencyCode: String,
                                        paymentMethods: [PaymentMethod]) {
        
        let metadata = TransactionMetaData(merchantName: transaction.merchantName,
                                           customerEmail: customerEmail,
                                           currencyCode: currencyCode,
                                           merchantLogoUrl: transaction.merchantLogoUrl,
                                           paymentMethods: paymentMethods)
        Monnify.shared.metadata = metadata
    }
}
