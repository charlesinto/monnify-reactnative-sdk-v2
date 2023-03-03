//
//  Secure3DAuthenticationViewController+BaseActiveViewDelegate.swift
//  Monnify
//
//  Created by Kanyinsola on 14/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

extension Secure3DAuthenticationViewController: Secure3DAuthenticationViewDelegate {
    
    func showLoading(text: String) {
        ViewUtils.hide(webKitView)
        ViewUtils.show(progressView)
        
        showLoading(withText: text,
                    activityIndicator: activityIndicator,
                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func dismissLoading() {
        
        ViewUtils.show(webKitView)
        ViewUtils.hide(progressView)
        dismissLoading(activityIndicator,
                       loadingMessageLabel)
    }
    
    func showTransactionStatus(viewModel: TransactionStatusViewModel) {
        let vc = viewController(type: TransactionStatusViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
