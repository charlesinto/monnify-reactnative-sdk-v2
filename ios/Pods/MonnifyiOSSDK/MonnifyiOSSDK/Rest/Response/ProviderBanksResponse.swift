//
//  ProviderBanksResponse.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 22/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import SwiftyJSON
import Foundation

struct ProviderBanksResponse: Mappable {

    let jsonString: String?
    let banks: [Bank]?

    init(_ json: JSON) {
        banks = json.arrayValue.map { Bank($0) }
        jsonString = json.string
    }
}
