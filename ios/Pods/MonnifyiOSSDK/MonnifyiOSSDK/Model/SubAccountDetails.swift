
//
//  SubAccountDetails.swift
//  Monnify
//
//  Created by Kanyinsola on 28/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

public struct SubAccountDetails {
    public let subAccountCode: String
    public let feePercentage: Float?
    public let splitAmount: Decimal?
    public let feeBearer: Bool?
    
    public init(subAccountCode: String,
                feePercentage: Float?,
                splitAmount: Decimal?,
                feeBearer: Bool?) {
        
        self.subAccountCode = subAccountCode
        self.feePercentage = feePercentage
        self.splitAmount = splitAmount
        self.feeBearer = feeBearer
    }
    
    func toDictionary() -> [String: Any] {
          var jsonDict = [String: Any]()
          jsonDict["subAccountCode"] = subAccountCode
          jsonDict["feePercentage"] = feePercentage
          jsonDict["splitAmount"] = splitAmount
          jsonDict["feeBearer"] = feeBearer
          return jsonDict
      }
}
