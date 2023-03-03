//
//  InitializeTransactionView.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol InitializeTransactionViewDelegate: BaseView {
    
    func showLoading(text: String)

    func dismissLoading()
    
    func showPaymentMethods(viewModel: PaymentMethodListViewModel)
    
    func showEmptyView()
}
