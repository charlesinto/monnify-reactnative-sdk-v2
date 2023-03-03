//
//  ChargeAccountRequest.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 30/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct ChargeAccountRequest {

    let transactionReference: String?
    let bankCode: String
    let apiKey: String?
    let accountNumber: String
    let collectionChannel: String = ApiConstants.AlternateCollectionChannel

    func toDictionary() -> [String: String] {
        var jsonDict = [String: String]()
        jsonDict["bankCode"] = bankCode
        jsonDict["transactionReference"] = transactionReference
        jsonDict["accountNumber"] = accountNumber
        jsonDict["apiKey"] = apiKey
        jsonDict["collectionChannel"] = collectionChannel
        return jsonDict
    }
}
