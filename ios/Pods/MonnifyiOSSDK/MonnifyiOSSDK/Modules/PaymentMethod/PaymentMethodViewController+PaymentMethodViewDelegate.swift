//
//  PaymentMethodViewController+PaymentMethodViewDelegate.swift
//  Monnify
//
//  Created by Kanyinsola on 11/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

extension PaymentMethodViewController : PaymentMethodViewDelegate {
   
    func showLoading(text: String) {
        
        ViewUtils.hide(paymentMethodTableView)

        showLoading(withText: text,
                    activityIndicator: activityIndicator,
                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func getViewModel() -> TransactionDetails {
        viewModel
    }
    
    func dismissLoading() {
        ViewUtils.show(paymentMethodTableView)

        dismissLoading(activityIndicator, loadingMessageLabel)
    }
    
    func showCardPayment(viewModel: CardPaymentViewModel) {

        let vc = viewController(type: CardPaymentViewController.self)
        vc.viewModel = viewModel
        popToOrPushViewController(vc: vc)
    }
    
    func showAccountTransferPayment(viewModel: AccountTransferViewModel) {
           
        let vc = viewController(type: AccountTransferViewController.self)
        vc.viewModel = viewModel
        popToOrPushViewController(vc: vc)

    }
    
    func showUssdTransferPayment(viewModel: UssdPaymentViewModel) {
           
        let vc = viewController(type: UssdPaymentViewController.self)
        vc.viewModel = viewModel
        popToOrPushViewController(vc: vc)

    }
    
    func showPhoneTransferPayment(viewModel: PhoneTransferViewModel) {
        let vc = viewController(type: PhoneTransferViewController.self)
        vc.viewModel = viewModel
        popToOrPushViewController(vc: vc)
    }
    
    func showBankTransferPayment(viewModel: BankTransferViewModel) {
        let vc = viewController(type: BankTransferViewController.self)
        vc.viewModel = viewModel
        popToOrPushViewController(vc: vc)
    }
    
}
