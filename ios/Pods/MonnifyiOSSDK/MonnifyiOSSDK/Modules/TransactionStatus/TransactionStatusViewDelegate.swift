//
//  TransactionStatusView.swift
//  Monnify
//
//  Created by Kanyinsola on 15/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol TransactionStatusViewDelegate : BaseView {
    func updateCountDownIndicator(withText text: String)
}
