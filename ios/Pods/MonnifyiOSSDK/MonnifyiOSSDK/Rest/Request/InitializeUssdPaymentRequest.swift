//
//  InitializeUssdPaymentRequest.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 17/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct InitializeUssdPaymentRequest {

    let transactionReference: String?
    let bankUssdCode: String

    func toDictionary() -> [String: String] {
        var jsonDict = [String: String]()
        jsonDict["bankUssdCode"] = bankUssdCode
        jsonDict["transactionReference"] = transactionReference
        return jsonDict
    }
}
