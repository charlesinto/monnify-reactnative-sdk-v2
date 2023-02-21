//
//  Secure3DPresenter.swift
//  Monnify
//
//  Created by Kanyinsola on 14/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol Secure3DPresenterProtocol : BaseActivePresenterProtocol {
    func authorizeSecure3d()
}

class Secure3DPresenter: BaseActivePresenter  {
    
    private weak var view: Secure3DAuthenticationViewDelegate?
    private var apiService: ApiServiceProtocol
    
    required init(view: Secure3DAuthenticationViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
        super.init(view: view, apiService: apiService)
    }
}

extension Secure3DPresenter: Secure3DPresenterProtocol {
    
    func authorizeSecure3d() {
        
        let monnify = Monnify.shared
        
        let apiKey = monnify.getApiKey() ?? ""
        let transactionReference = monnify.transactionResult.transactionReference
        
        let request = AuthorizeSecure3DSecureRequest(transactionReference: transactionReference,
                                                     apiKey: apiKey)
        apiService.authorize3DSecure(request: request) { _,_  in }   
    }
}
