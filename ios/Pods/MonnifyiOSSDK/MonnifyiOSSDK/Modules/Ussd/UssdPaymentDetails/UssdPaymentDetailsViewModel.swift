//
//  UssdPaymentDetailsViewModel.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 21/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct UssdPaymentDetailsViewModel : TransactionDetails {
    let bankName: String
    let ussdCode: String
    
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    
    let totalPayable: String
    let totalPayableAmount: Decimal?
    let itemValue: String? = nil
    let fee: String?
}
