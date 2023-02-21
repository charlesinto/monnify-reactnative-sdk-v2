//
//  PaymentMethodView.swift
//  Monnify
//
//  Created by Kanyinsola on 25/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol PaymentMethodViewDelegate: BaseView {
    func showLoading(text: String)
       
    func dismissLoading()
    
    func getViewModel() -> TransactionDetails
    
    func showCardPayment(viewModel: CardPaymentViewModel)
    
    func showAccountTransferPayment(viewModel: AccountTransferViewModel)
    
    func showUssdTransferPayment(viewModel: UssdPaymentViewModel)
    
    func showPhoneTransferPayment(viewModel: PhoneTransferViewModel)
    
    func showBankTransferPayment(viewModel: BankTransferViewModel)
}
