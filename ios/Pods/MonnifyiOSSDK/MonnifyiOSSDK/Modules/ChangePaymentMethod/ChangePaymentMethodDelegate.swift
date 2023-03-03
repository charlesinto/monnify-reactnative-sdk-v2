//
//  ChangePaymentMethodDelegate.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 13/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//


extension ChangePaymentMethodViewController : PaymentMethodViewDelegate {
   
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
