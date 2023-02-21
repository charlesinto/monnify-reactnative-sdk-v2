//
//  InitializeTransactionRequest.swift
//
//  Created on October 16, 2019
//
import Foundation


struct InitializeTransactionRequest {

	let amount: Decimal?
	let customerName: String?
	let customerEmail: String?
	let paymentReference: String?
	let paymentDescription: String?
	let currencyCode: String?
	let contractCode: String?
    let apiKey: String?
    let metaData: [String: String]?
    let paymentMethods: [PaymentMethod]?
    let incomeSplitConfig: [SubAccountDetails]?
    let collectionChannel = ApiConstants.AlternateCollectionChannel

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["amount"] = amount
        jsonDict["customerName"] = customerName
        jsonDict["customerEmail"] = customerEmail
        jsonDict["paymentReference"] = paymentReference
        jsonDict["paymentDescription"] = paymentDescription
        jsonDict["currencyCode"] = currencyCode
        jsonDict["contractCode"] = contractCode
        jsonDict["apiKey"] = apiKey
        jsonDict["metaData"] = metaData
        jsonDict["collectionChannel"] = collectionChannel
        jsonDict["incomeSplitConfig"] = incomeSplitConfig?.map{$0.toDictionary()}
        jsonDict["paymentMethods"] = paymentMethods?.map{ $0.rawValue }

        return jsonDict
    }
}
