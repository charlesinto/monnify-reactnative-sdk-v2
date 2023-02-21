//
//  PaymentMethodData.swift
//  Monnify
//
//  Created by Kanyinsola on 25/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

struct PaymentMethodData {
    
    static let AccountTransfer = PaymentMethodViewModel(title: "Pay with Transfer",
                                                     subtitle: "Transfer to a Merchants Account",
                                                     icon: UIImage.initWithName("bank-transfer-icon")!)
    
    static let card = PaymentMethodViewModel(title: "Pay with Card",
                                             subtitle: "Payment with your Debit Card",
                                             icon: UIImage.initWithName("pay-with-card-icon")!)
    
    static let qrCode = PaymentMethodViewModel(title: "Pay with NQR",
                                               subtitle: "Scan a QR-Code to complete payment",
                                               icon: UIImage.initWithName("pay-with-card-icon")!)

    static let ussd = PaymentMethodViewModel(title: "Pay with USSD",
                                             subtitle: "Use your Banks USSD platform to Pay",
                                             icon: UIImage.initWithName("pay-with-ussd-icon")!)
    
    static let directDebit = PaymentMethodViewModel(title: "Pay with Bank",
                                                subtitle: "",
                                                icon: UIImage.initWithName("pay-with-bank")!)
    static let phone = PaymentMethodViewModel(title: "Pay with Phone No.",
                                                subtitle: "",
                                                icon: UIImage.initWithName("pay-with-phone")!)
}
