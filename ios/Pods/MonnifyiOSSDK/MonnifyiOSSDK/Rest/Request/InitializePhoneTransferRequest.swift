//
//  InitializePhoneTransferRequest.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 22/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

struct InitializePhoneTransferRequest {

    let phoneNumber: String?
    let transactionReference: String?

    func toDictionary() -> [String: String] {
        var jsonDict = [String: String]()
        jsonDict["phoneNumber"] = phoneNumber
        jsonDict["transactionReference"] = transactionReference
        return jsonDict
    }
}
