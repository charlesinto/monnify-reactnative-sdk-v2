//
//  ChargeAccountResponseBody.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 30/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//


import Foundation

import SwiftyJSON

struct ChargeAccountResponseBody : Mappable {
    
    let status: String
    let responseDescription: String
    let transactionReference: String
    let providerReference: String?
    init(_ json: JSON) {
        status = json["status"].stringValue
        responseDescription = json["responseDescription"].stringValue
        transactionReference = json["transactionReference"].stringValue
        providerReference = json["providerReference"].stringValue
        
    }
}
