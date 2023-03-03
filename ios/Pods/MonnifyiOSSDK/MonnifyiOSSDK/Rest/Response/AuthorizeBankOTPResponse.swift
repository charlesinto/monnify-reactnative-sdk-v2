//
//  AuthorizeOTPResponse.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 04/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//


import Foundation

import SwiftyJSON

struct AuthorizeBankOTPResponseBody : Mappable {
    
    let status: BankChargeStatus?
    let responseDescription: String
    let transactionReference: String
    init(_ json: JSON) {
        status = BankChargeStatus(rawValue: json["status"].stringValue)
        responseDescription = json["responseDescription"].stringValue
        transactionReference = json["transactionReference"].stringValue
        
    }
}

