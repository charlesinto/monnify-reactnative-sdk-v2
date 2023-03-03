//
//  GetAccountDetailsResponse.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 24/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

import SwiftyJSON

struct GetAccountDetailsResponseBody : Mappable {
    
    let additionalInfoRequired: Bool
    let transactionReference: String
    let accountNumber: String
    let accountName: String
    
    init(_ json: JSON) {
        additionalInfoRequired = json["additionalInfoRequired"].boolValue
        accountNumber = json["accountNumber"].stringValue
        transactionReference = json["transactionReference"].stringValue
        accountName = json["accountName"].stringValue
    }
}
