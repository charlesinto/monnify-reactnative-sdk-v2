//
//  TransactionStatusResponse.swift
//
//  Created on November 12, 2019
//
import SwiftyJSON

struct TransactionStatusResponseBody : Mappable {

	let paymentMethod: String
	let createdOn: String
	let amountPaid: Decimal
	let flagged: Bool
	let providerCode: String
	let fee: Decimal
	let currencyCode: String
	let customerName: String
	let customerEmail: String
	let paymentDescription: String
	let paymentStatus: String
	let transactionReference: String
	let paymentReference: String
	let merchantCode: String
	let payableAmount: Decimal
    
	init(_ json: JSON) {
		paymentMethod = json["paymentMethod"].stringValue
		createdOn = json["createdOn"].stringValue
        amountPaid = Decimal.init( json["amountPaid"].doubleValue)
		flagged = json["flagged"].boolValue
		providerCode = json["providerCode"].stringValue
		fee = Decimal.init(json["fee"].doubleValue)
		currencyCode = json["currencyCode"].stringValue
		customerName = json["customerName"].stringValue
		customerEmail = json["customerEmail"].stringValue
		paymentDescription = json["paymentDescription"].stringValue
		paymentStatus = json["paymentStatus"].stringValue
		transactionReference = json["transactionReference"].stringValue
		paymentReference = json["paymentReference"].stringValue
		merchantCode = json["merchantCode"].stringValue
		payableAmount = Decimal.init(json["payableAmount"].doubleValue)
	}

}
