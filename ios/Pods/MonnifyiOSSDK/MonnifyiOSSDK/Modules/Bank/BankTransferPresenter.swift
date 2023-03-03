//
//  BankTransferPresenter.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 22/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol BankTransferPresenterProtocol : BasePresenter {
    
    func initializeBankTransferDetails(_ bankCode: String, _ bankName: String)
}

class BankTransferPresenter: BankTransferPresenterProtocol  {
    
    private weak var view: BankTransferViewDelegate?
    private var apiService: ApiServiceProtocol
    
    
    required init(view: BankTransferViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
    }
    
    
    func initializeBankTransferDetails(_ bankCode: String, _ bankName: String){
        //let monnify = Monnify.shared
        //        let request = InitializeUssdPaymentRequest(transactionReference: monnify.transactionResult.transactionReference, bankUssdCode: bankCode)
        //        let currencyCode = monnify.metadata.currencyCode
        //
        //        view?.showLoading(text: StringLiterals.PleaseWait)
        //
        //
        //        apiService.initializeUssdPayment(request: request) { [weak self] (response, _) in
        //
        //            guard let self = self else { return }
        //
        //            self.view?.dismissLoading()
        //
        //            guard let response = response else {
        //                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
        //                                           message: StringLiterals.GenericNetworkError)
        //                return
        //            }
        //
        //            guard response.isSuccessful, let transaction = response.responseBody else {
        //                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
        //                                           message: response.responseMessage
        //                                           ?? "An unexpected error occurred please contact support.")
        //                return
        //            }
        //
        let _ = Monnify.shared.metadata
        //            let totalAmountPayable = transaction.amount.commaSeparatedNairaValue(currencyCode: currencyCode)
        //
        //
        let viewModel = self.view!.getViewModel()
        
        let bankTransferDetailsVM = BankTransferDetailsViewModel(
            bankName: bankName,
            bankCode: bankCode,
            totalPayable: viewModel.totalPayable,
            merchantName: viewModel.merchantName,
            customerEmail: viewModel.customerEmail,
            merchantLogoUrl: viewModel.merchantLogoUrl, totalPayableAmount: viewModel.totalPayableAmount,
            itemValue: viewModel.itemValue,
            fee: viewModel.fee)
        
        self.view?.showBankTransferDetails(viewModel: bankTransferDetailsVM)
        
    }
}



