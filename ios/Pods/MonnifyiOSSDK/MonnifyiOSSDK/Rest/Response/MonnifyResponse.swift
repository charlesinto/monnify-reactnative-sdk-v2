//
//  MonnifyResponse.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//
import SwiftyJSON

class MonnifyResponse<T: Mappable>: Mappable {
    
    let requestSuccessful: Bool?
    let responseMessage: String?
    let responseCode: String?
    let responseBody: T?

    required init(_ json: JSON) {
        requestSuccessful = json["requestSuccessful"].boolValue
        responseMessage = json["responseMessage"].stringValue
        responseCode = json["responseCode"].stringValue
        responseBody = createModel(model: T.self, json: json["responseBody"])
    }
    
    var isSuccessful : Bool {
        return requestSuccessful ?? false && responseMessage?.lowercased() == "success"
    }
}
