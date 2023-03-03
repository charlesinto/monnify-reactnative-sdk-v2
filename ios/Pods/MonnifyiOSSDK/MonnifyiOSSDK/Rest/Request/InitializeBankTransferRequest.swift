//
//  InitializeBankTransferRequest.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 22/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct InitializeBankTransferRequest {

    let collectionChannel = ApiConstants.AlternateCollectionChannel
    let transactionReference: String?
    let apiKey: String?

    func toDictionary() -> [String: String] {
        var jsonDict = [String: String]()
        jsonDict["collectionChannel"] = collectionChannel
        jsonDict["transactionReference"] = transactionReference
        jsonDict["apiKey"] = apiKey
        return jsonDict
    }
}
