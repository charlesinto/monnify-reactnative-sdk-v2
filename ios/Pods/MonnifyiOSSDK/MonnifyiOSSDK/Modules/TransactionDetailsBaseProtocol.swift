//
//  TransactionDetailsBaseProtocol.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 13/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

protocol TransactionDetails {
    var merchantName: String { get }
    var customerEmail: String { get }
    var merchantLogoUrl: String? { get }
    var totalPayable: String { get }
    var totalPayableAmount: Decimal? { get }
    var itemValue: String? { get }
    var fee: String? { get }
}
