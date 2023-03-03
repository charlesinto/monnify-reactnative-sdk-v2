//
//  CardRequirementRequest.swift
//  MonnifyiOSSDK
//
//  Created by Nathaniel Ogunye on 16/11/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct CardRequirementRequest {
    
    let pan: String?
    let transactionReference: String?
    let collectionChannel: String = ApiConstants.CollectionChannel
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["pan"] = pan
        jsonDict["transactionReference"] = transactionReference
        jsonDict["collectionChannel"] = collectionChannel
        return jsonDict
    }
    
}
