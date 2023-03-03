//
//  CardPaymentViewController+CardPaymentViewDelegate.swift
//  Monnify
//
//  Created by Kanyinsola on 12/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

extension CardPaymentViewController: CardPaymentViewDelegate {
    
    func openEnterOTPViewController(viewModel: EnterOTPViewModel) {
        
        let vc = viewController(type: EnterOTPViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func open3DSAuthWebView(secure3dData: Secure3dData) {
        let vc = viewController(type: Secure3DAuthenticationViewController.self)
        vc.secure3DSData = secure3dData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLoading(text: String) {
        
        ViewUtils.hide(cardNumberTextfield, expiryDataTextfield, cvvTextfield, pinViewContainer)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        showLoading(withText: text,
                    activityIndicator: activityIndicator,
                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func dismissLoading() {
        ViewUtils.show(cardNumberTextfield, expiryDataTextfield, cvvTextfield, pinViewContainer)
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismissLoading(activityIndicator, loadingMessageLabel)
    }
    
    func showPinView() {
        pinViewContainer.fadeIn()
    }
    
    func showTransactionStatus(viewModel: TransactionStatusViewModel) {
        let vc = viewController(type: TransactionStatusViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
