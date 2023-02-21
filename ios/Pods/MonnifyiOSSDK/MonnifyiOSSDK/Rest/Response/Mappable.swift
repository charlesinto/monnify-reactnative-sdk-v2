//
//  Mappable.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//
import SwiftyJSON

protocol Mappable {
    init(_ json: JSON)
}

func createModel<T: Mappable>(model: T.Type, json: JSON) -> T {
    return model.init(json)
}
