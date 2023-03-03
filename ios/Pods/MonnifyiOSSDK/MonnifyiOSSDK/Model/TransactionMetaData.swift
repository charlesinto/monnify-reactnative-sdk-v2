//
//  TransactionMetaData.swift
//  Monnify
//
//  Created by Kanyinsola on 13/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

struct TransactionMetaData {
    let merchantName: String
    let customerEmail: String
    let currencyCode: String
    let merchantLogoUrl: String?
    let paymentMethods: [PaymentMethod]
}
