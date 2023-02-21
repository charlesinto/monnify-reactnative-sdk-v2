//
//  UssdPaymentViewPresenter.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 17/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol UssdTransferPresenterProtocol : BasePresenter {
    
    func initializeUssdPaymentDetails(_ bankUssdCode: String, _ bankName: String)
}

class UssdPaymentPresenter: UssdTransferPresenterProtocol  {
    
    private weak var view: UssdPaymentViewDelegate?
    private var apiService: ApiServiceProtocol
    
    
    required init(view: UssdPaymentViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
    }
    
    
    func initializeUssdPaymentDetails(_ bankUssdCode: String, _ bankName: String){
        let monnify = Monnify.shared
        let request = InitializeUssdPaymentRequest(transactionReference: monnify.transactionResult.transactionReference, bankUssdCode: bankUssdCode)
        let currencyCode = monnify.metadata.currencyCode
        
        view?.showLoading(text: StringLiterals.PleaseWait)

        
        apiService.initializeUssdPayment(request: request) { [weak self] (response, _) in
            
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
            
            let metadata = Monnify.shared.metadata
            let totalAmountPayable = transaction.amount.commaSeparatedNairaValue(currencyCode: currencyCode)
            
            
            let ussdDetailsVM = UssdPaymentDetailsViewModel(
                bankName: bankName,
                ussdCode: transaction.paymentCode,
                merchantName:  metadata?.merchantName ?? "NA",
                customerEmail: metadata?.customerEmail ?? "NA",
                merchantLogoUrl: metadata?.merchantLogoUrl,
                totalPayable: totalAmountPayable,
                totalPayableAmount: transaction.amount,
                fee: 0.00.commaSeparatedNairaValue()
            )
            
        
            
            
            self.view?.showUssdTransferDetails(viewModel: ussdDetailsVM)
            
        }
    }
    
    
}
