//
//  BankTransferDetailsViewModel.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 23/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct BankTransferDetailsViewModel: TransactionDetails {
    let bankName: String
    let bankCode: String
    
    let totalPayable: String
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    let totalPayableAmount: Decimal?
    let itemValue: String?
    let fee: String?
}
