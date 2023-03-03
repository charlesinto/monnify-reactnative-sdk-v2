//
//  CardPaymentViewModel.swift
//  Monnify
//
//  Created by Kanyinsola on 11/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

struct CardPaymentViewModel : TransactionDetails {
        
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    let totalPayable: String
    let amountPayable: String
    let fee: String?
    let totalPayableAmount: Decimal?
    let itemValue: String? = nil
}
