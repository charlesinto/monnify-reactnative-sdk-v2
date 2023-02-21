//
//  GetAccountDetailsRequest.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 24/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct GetAccountDetailsRequest {

    let transactionReference: String?
    let bankCode: String
    let accountNumber: String

    func toDictionary() -> [String: String] {
        var jsonDict = [String: String]()
        jsonDict["bankCode"] = bankCode
        jsonDict["transactionReference"] = transactionReference
        jsonDict["accountNumber"] = accountNumber
        return jsonDict
    }
}
