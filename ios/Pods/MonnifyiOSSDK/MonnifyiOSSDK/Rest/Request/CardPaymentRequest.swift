//
//  CardPaymentRequest.swift
//
//  Created on November 12, 2019
//
import Foundation

struct CardPaymentRequest {

	let transactionReference: String?
	let apiKey: String?
    let collectionChannel =  ApiConstants.CollectionChannel
	let card: Card?

	func toDictionary() -> [String: Any] {
		var jsonDict = [String: Any]()
		jsonDict["transactionReference"] = transactionReference
		jsonDict["apiKey"] = apiKey
		jsonDict["collectionChannel"] = collectionChannel
		jsonDict["card"] = card?.toDictionary()
		return jsonDict
	}
    
}
