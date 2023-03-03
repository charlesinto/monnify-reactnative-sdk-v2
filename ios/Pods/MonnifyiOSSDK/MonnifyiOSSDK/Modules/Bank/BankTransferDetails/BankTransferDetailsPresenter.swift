//
//  BankTransferDetailsPresenter.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 23/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol BankTransferDetailsPresenterProtocol : BasePresenter {
    
    
    func getAccountDetails(bankCode: String, accountNumber: String)
    
    func showOTPScreen(bankCode: String, accountNumber: String)
    
}

class BankTransferDetailsPresenter: BankTransferDetailsPresenterProtocol  {
    
    
    private weak var view: BankTransferDetailsViewDelegate?
    private var apiService: ApiServiceProtocol
    
    
    required init(view: BankTransferDetailsViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
    }
    
    
    func getAccountDetails( bankCode: String, accountNumber: String) {
        let monnify = Monnify.shared
        let request = GetAccountDetailsRequest(transactionReference: monnify.transactionResult.transactionReference, bankCode: bankCode, accountNumber: accountNumber)
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
        apiService.getAccountDetails(request: request) { [weak self] (response, _) in
       
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
            
            self.view?.updateAccountDetails(accountName: transaction.accountName)
       
        }
    }
    
    func showOTPScreen(bankCode: String, accountNumber: String) {
        let monnify = Monnify.shared
        let request = ChargeAccountRequest(transactionReference: monnify.transactionResult.transactionReference, bankCode: bankCode, apiKey: monnify.getApiKey(), accountNumber: accountNumber)
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
        apiService.chargeAccount (request: request) { [weak self] (response, _) in
       
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
            
            let metaData = monnify.metadata!
            let viewModel = self.view!.getViewModel()
            
            let enterOTPVM = EnterOTPViewModel(
                tokenData: nil,
                providerReference: transaction.providerReference,
                paymentMethod: .bank,
                merchantName:  metaData.merchantName,
                customerEmail:  metaData.customerEmail,
                merchantLogoUrl: metaData.merchantLogoUrl,
                totalPayable: viewModel.totalPayable,
                totalPayableAmount: 0.0,
                itemValue: viewModel.itemValue,
                fee: viewModel.fee
            )
            
            self.view?.showOTPScreen(viewModel: enterOTPVM)
       
        }
    }
}
