//
//  InitializeCardPaymentRequest.swift
//
//  Created on November 09, 2019
//
import Foundation

struct InitializeCardPaymentRequest {
    
	let transactionReference: String?
	let apiKey: String?
	let collectionChannel = ApiConstants.AlternateCollectionChannel

	func toDictionary() -> [String: String] {
		var jsonDict = [String: String]()
		jsonDict["transactionReference"] = transactionReference
		jsonDict["apiKey"] = apiKey
		jsonDict["collectionChannel"] = collectionChannel
		return jsonDict
	}
    
}
