//
//  EnterOTPViewDelegate.swift
//  Monnify
//
//  Created by Kanyinsola on 13/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol EnterOTPViewDelegate: BaseView {
    
    func showLoading(text: String)
    
    func dismissLoading()
    
    func open3DSAuthWebView(secure3dData: Secure3dData)
    
    func showTransactionStatus(viewModel: TransactionStatusViewModel)
    
    func getViewModel() -> EnterOTPViewModel

}
