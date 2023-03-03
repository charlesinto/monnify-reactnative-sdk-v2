//
//  TokenData.swift
//
//  Created on November 12, 2019
//
import Foundation
import SwiftyJSON

struct TokenData {

	let id: String?
	let message: String?

	init(_ json: JSON) {
		id = json["id"].stringValue
		message = json["message"].stringValue
	}

}
