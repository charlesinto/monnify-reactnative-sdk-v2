//
//  AuthorizeBankOtpRequest.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 04/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct AuthorizeBankOtpRequest {
    
    let transactionReference: String
    let providerReference: String
    let apiKey: String
    let collectionChannel = ApiConstants.AlternateCollectionChannel
    let token: String

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["transactionReference"] = transactionReference
        jsonDict["providerReference"] = providerReference
        jsonDict["apiKey"] = apiKey
        jsonDict["collectionChannel"] = collectionChannel
        jsonDict["token"] = token

        return jsonDict
    }
}
