//
//  Environment.swift
//  Monnify
//
//  Created by Kanyinsola on 06/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

enum Environment : String {
    case prod_live = "api.monnify.com"
    case prod_sandbox = "sandbox.monnify.com"
    case staging_live = "api.staging.monnify.com"
    case staging_sandbox = "sandbox.staging.monnify.com"
    case playground_live = "monnify.payment.engine.playground.teamapt.com"
    case playground_sandbox = "sandbox.monnify.payment.engine.playground.teamapt.com"
}

extension Environment {
    var httpBaseUrl : String {
        return "http://\(self.rawValue)"
    }
    
    var httpsBaseUrl : String {
        return "https://\(self.rawValue)"
    }
    
    var webSocketHTTPSConnectionUrl : String {
        return "https://\(self.rawValue)"
    }
    
    var webSocketHTTPConnectionUrl : String {
        return "http://\(self.rawValue)"
    }
    
    var version: String {
        return "api/v1/sdk"
    }
}
