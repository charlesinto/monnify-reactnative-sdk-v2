//
//  InitializePhoneTransferResponseBody.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 22/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

import SwiftyJSON

struct InitializePhoneTransferResponseBody : Mappable {
    
    let transactionReference: String
    let totalAmountPayable: Decimal
    let amount: Decimal
    let paymentFee: Decimal
    
    init(_ json: JSON) {
        transactionReference = json["transactionReference"].stringValue
        amount = Decimal(json["amount"].doubleValue )
        totalAmountPayable =  Decimal(json["totalAmountPayable"].doubleValue )
        paymentFee =  Decimal(json["paymentFee"].doubleValue )
    }
}
