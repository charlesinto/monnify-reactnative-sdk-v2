//
//  PaymentMethodViewModel.swift
//  Monnify
//
//  Created by Kanyinsola on 10/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

struct PaymentMethodViewModel {
    let title: String
    let subtitle: String
    let icon: UIImage
    
    static func fromPaymentMethod(paymentMethod: PaymentMethod) -> PaymentMethodViewModel {
        
        switch paymentMethod {
        case .accountTransfer:
            return PaymentMethodData.AccountTransfer
            
        case .card:
            return PaymentMethodData.card
        case .ussd:
            return PaymentMethodData.ussd
        case .bank:
            return PaymentMethodData.directDebit
        case .phone:
            return PaymentMethodData.phone
        }
    }
}

struct PaymentMethodListViewModel: TransactionDetails {
    let paymentMethods : [PaymentMethod]
    let transactionReference: String
    let totalPayable: String
    let merchantName: String
    let customerEmail: String
    let merchantLogoUrl: String?
    
    let totalPayableAmount: Decimal? = nil
    let itemValue: String? = nil
    let fee: String? = nil
}
