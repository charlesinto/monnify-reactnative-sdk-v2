//
//  UssdPaymentViewModel.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 17/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct UssdPaymentViewModel : TransactionDetails {
    let banks: [Bank]
    
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    
    let totalPayable: String
    let totalPayableAmount: Decimal? = nil
    let itemValue: String? = nil
    let fee: String? = nil
}
