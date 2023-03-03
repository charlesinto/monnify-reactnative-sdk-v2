//
//  CardPaymentResponseBody.swift
//
//  Created on November 12, 2019
//
import Foundation
import SwiftyJSON

struct CardPaymentResponseBody: Mappable {
    
    let status: CardChargeStatus?
    let message: String
    let cardToken: String
    let tokenData: TokenData
    let secure3dData: Secure3dData
    let responseCode: String
    let responseDescription: String
    let transactionReference: String
    let paymentReference: String
    let authorizedAmount: Decimal
    
    init(_ json: JSON) {
        status = CardChargeStatus(rawValue: json["status"].stringValue)
        message = json["message"].stringValue
        cardToken = json["cardToken"].stringValue
        tokenData = TokenData(json["otpData"])
        secure3dData = Secure3dData(json["secure3dData"])
        responseCode = json["responseCode"].stringValue
        responseDescription = json["responseDescription"].stringValue
        transactionReference = json["transactionReference"].stringValue
        paymentReference = json["paymentReference"].stringValue
        authorizedAmount = Decimal( json["authorizedAmount"].doubleValue )
    }
}
