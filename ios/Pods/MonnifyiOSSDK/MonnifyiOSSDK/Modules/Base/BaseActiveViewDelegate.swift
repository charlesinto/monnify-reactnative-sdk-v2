//
//  BaseActiveViewDelegate.swift
//  Monnify
//
//  Created by Kanyinsola on 14/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol BaseActiveViewDelegate : BaseView {
    func showTransactionStatus(viewModel: TransactionStatusViewModel)
}
