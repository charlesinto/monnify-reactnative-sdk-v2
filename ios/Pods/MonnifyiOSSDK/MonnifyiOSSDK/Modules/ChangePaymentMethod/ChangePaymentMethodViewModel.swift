//
//  ChangePaymentMethodViewModel.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 13/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct ChangePaymentMethodViewModel: TransactionDetails {
    let paymentMethods : [PaymentMethod]
    let currentPaymentMethod : PaymentMethod

    let totalPayable: String
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    
    let totalPayableAmount: Decimal? = nil
    let itemValue: String? = nil
    let fee: String? = nil
}
