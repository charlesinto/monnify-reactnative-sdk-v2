//
//  BankTransferStatusRequest.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 04/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct BankTransferStatusRequest {

    let transactionReference: String?
    let providerReference: String?
    let collectionChannel: String = ApiConstants.AlternateCollectionChannel

    func toDictionary() -> [String: String] {
        var jsonDict = [String: String]()
        jsonDict["transactionReference"] = transactionReference
        jsonDict["providerReference"] = providerReference
        jsonDict["collectionChannel"] = collectionChannel
        return jsonDict
    }
}
