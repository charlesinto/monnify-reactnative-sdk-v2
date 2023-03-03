//
//  CardPaymentResponseBody.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//
import SwiftyJSON

struct InitializeCardPaymentResponseBody : Mappable {
    
    let transactionReference: String
    let totalAmountPayable: Decimal
    let amount: Decimal
    
    init(_ json: JSON) {
        transactionReference = json["transactionReference"].stringValue
        amount = Decimal(json["amount"].doubleValue )
        totalAmountPayable =  Decimal(json["totalAmountPayable"].doubleValue )
    }
}
