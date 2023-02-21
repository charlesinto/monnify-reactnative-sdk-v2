//
//  ResponseBody.swift
//
//  Created on October 16, 2019
//

import Foundation
import SwiftyJSON


struct InitializeAccountTransferResponseBody : Mappable {
    
    let accountNumber: String
	let accountName: String
	let bankName: String
	let accountDurationSeconds: Int
	let ussdPayment: Any
	let requestTime: String
	let transactionReference: String
	let paymentReference: String
	let amount: Decimal
	let fee: Decimal
    let totalPayable: Decimal
    let productInformation: Any

    init(_ json: JSON) {
		accountNumber = json["accountNumber"].stringValue
		accountName = json["accountName"].stringValue
		bankName = json["bankName"].stringValue
		accountDurationSeconds = json["accountDurationSeconds"].intValue
		ussdPayment = json["ussdPayment"]
		requestTime = json["requestTime"].stringValue
		transactionReference = json["transactionReference"].stringValue
		paymentReference = json["paymentReference"].stringValue
        amount = Decimal(json["amount"].doubleValue)
        fee = Decimal(json["fee"].doubleValue)
        totalPayable = Decimal(json["totalPayable"].doubleValue)
        productInformation = json["productInformation"]
	}
}
