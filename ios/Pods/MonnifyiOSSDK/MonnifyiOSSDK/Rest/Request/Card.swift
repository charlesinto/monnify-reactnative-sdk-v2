//
//  Card.swift
//
//  Created on November 12, 2019
//
import Foundation

struct Card {

	let number: String?
	let cvv: String?
	let expiryMonth: Int?
	let expiryYear: Int?
	let pin: String?

	func toDictionary() -> [String: Any] {
		var jsonDict = [String: Any]()
		jsonDict["number"] = number
		jsonDict["cvv"] = cvv
		jsonDict["expiryMonth"] = expiryMonth
		jsonDict["expiryYear"] = expiryYear
		jsonDict["pin"] = pin
		return jsonDict
	}

}
