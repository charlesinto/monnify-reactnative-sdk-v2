//
//  AccountTransferRequest.swift
//
//  Created on October 16, 2019
//
import Foundation


struct InitializeAccountTransferRequest {

    let collectionChannel = ApiConstants.AlternateCollectionChannel
	let transactionReference: String?
	let apiKey: String?

    func toDictionary() -> [String: String] {
        var jsonDict = [String: String]()
        jsonDict["collectionChannel"] = collectionChannel
        jsonDict["transactionReference"] = transactionReference
        jsonDict["apiKey"] = apiKey
        return jsonDict
    }
}

typealias AuthorizeSecure3DSecureRequest = InitializeAccountTransferRequest
