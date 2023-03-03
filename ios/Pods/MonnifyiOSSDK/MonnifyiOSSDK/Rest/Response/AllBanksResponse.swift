//
//  AllBanksResponse.swift
//
//  Created on November 12, 2019
//

import SwiftyJSON
import Foundation

struct AllBanksResponse: Mappable {

    let jsonString: String?
	let banks: [Bank]?

	init(_ json: JSON) {
		banks = json.arrayValue.map { Bank($0) }
        jsonString = json.string
	}
}
