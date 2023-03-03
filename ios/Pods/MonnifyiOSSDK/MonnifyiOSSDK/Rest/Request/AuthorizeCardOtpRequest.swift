//
//  AuthorizeCardOtpRequest.swift
//  Monnify
//
//  Created by Kanyinsola on 12/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

struct AuthorizeCardOtpRequest {
    
    let transactionReference: String?
    let apiKey: String?
    let collectionChannel = ApiConstants.AlternateCollectionChannel
    let token: String?
    let tokenId: String?

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["transactionReference"] = transactionReference
        jsonDict["apiKey"] = apiKey
        jsonDict["collectionChannel"] = collectionChannel
        jsonDict["token"] = token
        jsonDict["tokenId"] = tokenId

        return jsonDict
    }
}
