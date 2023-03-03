//
//  ResponseBody.swift
//
//  Created on November 12, 2019
//
import Foundation
import SwiftyJSON

struct Bank : Codable {

	let name: String?
	let code: String?
	let ussdTemplate: String?
	let baseUssdCode: String?
	let transferUssdTemplate: String?

	init(_ json: JSON) {
		name = json["name"].stringValue
		code = json["code"].stringValue
		ussdTemplate = json["ussdTemplate"].stringValue
		baseUssdCode = json["baseUssdCode"].stringValue
		transferUssdTemplate = json["transferUssdTemplate"].stringValue
	}

}
