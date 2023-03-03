//
//  PaymentMethod.swift
//  Monnify
//
//  Created by Kanyinsola on 25/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

public enum PaymentMethod : String {
    
    case card = "CARD"
    case accountTransfer = "ACCOUNT_TRANSFER"
    case ussd = "USSD"
    case phone = "PHONE_NUMBER"
    case bank = "DIRECT_DEBIT"
    


   public static let all : [PaymentMethod] = [ .card, .accountTransfer, .ussd, .phone, .bank]
}
