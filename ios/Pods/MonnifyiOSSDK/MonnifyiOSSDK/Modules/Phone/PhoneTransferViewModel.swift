//
//  PhonePaymentViewModel.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 21/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct PhoneTransferViewModel : TransactionDetails {    
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    
    let totalPayable: String
    let totalPayableAmount: Decimal? = nil
    let itemValue: String? = nil
    let fee: String?
    
}
