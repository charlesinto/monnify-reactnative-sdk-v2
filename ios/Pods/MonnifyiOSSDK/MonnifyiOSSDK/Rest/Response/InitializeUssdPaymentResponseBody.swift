//
//  InitializeUssdPaymentResponseBody.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 17/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import SwiftyJSON

struct InitializeUssdPaymentResponseBody : Mappable {
    let ussdCode: String
    let paymentCode: String
    let providerReference: String
    let transactionReference: String
    let amount: Decimal
    
    init(_ json: JSON) {
        ussdCode = json["bankUssdCode"].stringValue
        paymentCode = json["paymentCode"].stringValue
        providerReference = json["providerReference"].stringValue
        transactionReference = json["transactionReference"].stringValue
        amount = Decimal(json["authorizedAmount"].doubleValue )
    }
}
