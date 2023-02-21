//
//  CardRequirementsResponse.swift
//  Monnify
//
//  Created by Kanyinsola on 11/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//
import SwiftyJSON

struct CardRequirementsResponseBody : Mappable {
    
    let requirePin: Bool
    
    init(_ json: JSON) {
        requirePin = json["requirePin"].boolValue
    }
}

