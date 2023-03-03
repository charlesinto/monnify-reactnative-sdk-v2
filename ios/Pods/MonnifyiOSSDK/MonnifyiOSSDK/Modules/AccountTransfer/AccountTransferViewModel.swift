//
//  AccountTransferViewModel.swift
//  Monnify
//
//  Created by Kanyinsola on 15/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

struct AccountTransferViewModel : TransactionDetails {
    
    let bankName: String
    let accountNumber: String
    let accountName: String
    let accountDurationSeconds: Int
    let banks: [Bank]
    
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    
    let totalPayable: String
    let totalPayableAmount: Decimal? = nil
    let itemValue: String? = nil
    let fee: String? = nil
}
