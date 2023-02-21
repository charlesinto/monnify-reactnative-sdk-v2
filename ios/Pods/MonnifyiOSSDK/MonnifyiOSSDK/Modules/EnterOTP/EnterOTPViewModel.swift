//
//  EnterOTPViewModel.swift
//  Monnify
//
//  Created by Kanyinsola on 13/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

struct EnterOTPViewModel : TransactionDetails {
    
    let tokenData: TokenData?
    let providerReference: String?
    let paymentMethod: PaymentMethod
    
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    
    let totalPayable: String
    let totalPayableAmount: Decimal?
    let itemValue: String?
    let fee: String?

}
