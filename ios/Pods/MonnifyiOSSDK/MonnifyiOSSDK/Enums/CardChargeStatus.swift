//
//  CardChargeStatus.swift
//  Monnify
//
//  Created by Kanyinsola on 12/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

enum CardChargeStatus: String {
    case pending = "PENDING"
    case success = "SUCCESS"
    case otpAuthorizationRequired = "OTP_AUTHORIZATION_REQUIRED"
    case bankAuthorizationRequired = "BANK_AUTHORIZATION_REQUIRED"
    case authenticationFailed = "AUTHENTICATION_FAILED"
    case pinRequired = "PIN_REQUIRED"
    case failed = "FAILED"
}
