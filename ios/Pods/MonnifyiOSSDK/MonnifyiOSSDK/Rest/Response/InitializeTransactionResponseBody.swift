import Foundation
import SwiftyJSON

struct InitializeTransactionResponseBody : Mappable {

	let transactionReference: String
	let merchantName: String
	let merchantLogoUrl: String
	let enabledPaymentMethod: [String]

    init(_ json: JSON) {
		transactionReference = json["transactionReference"].stringValue
		merchantName = json["merchantName"].stringValue
        merchantLogoUrl = json["merchantLogoUrl"].stringValue
		enabledPaymentMethod = json["enabledPaymentMethod"].arrayValue.map { $0.stringValue }
	}
}
