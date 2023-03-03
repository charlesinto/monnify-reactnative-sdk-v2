//
//  CardPaymentViewDelegate.swift
//  Monnify
//
//  Created by Kanyinsola on 12/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol CardPaymentViewDelegate: BaseView {
    
    func showLoading(text: String)
    
    func dismissLoading()
    
    func showPinView()
    
    func openEnterOTPViewController(viewModel: EnterOTPViewModel)
    
    func open3DSAuthWebView(secure3dData: Secure3dData)

    func showTransactionStatus(viewModel: TransactionStatusViewModel)
}
