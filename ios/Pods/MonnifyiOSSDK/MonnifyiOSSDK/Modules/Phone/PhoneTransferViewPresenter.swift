//
//  PhoneTransferViewPresenter.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 06/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol PhoneTransferPresenterProtocol : BaseActivePresenterProtocol {
    
    
    func initializePhoneTransfer(phoneNumber: String)
    
    
}

class PhoneTransferPresenter: BaseActivePresenter, PhoneTransferPresenterProtocol  {
    
    
    private weak var view: PhoneTransferViewDelegate?
    private var apiService: ApiServiceProtocol
    
    
    required init(view: PhoneTransferViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
        super.init(view: view, apiService: apiService)
    }
    
    override func stopListening() {
        super.stopListening()
    }
    
    func initializePhoneTransfer(phoneNumber: String) {
        let monnify = Monnify.shared
        let request = InitializePhoneTransferRequest(phoneNumber: phoneNumber, transactionReference: monnify.transactionResult.transactionReference)
        
        view?.showLoading(text: StringLiterals.PleaseWait)
      
        
        apiService.initializePhoneTransferPayment(request: request) { [weak self] (response, _) in
       
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
            
       
        }
    }
    
    
}

