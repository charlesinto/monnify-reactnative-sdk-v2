//
//  Config.swift
//  MonnifyiOSSDK
//
//  Created by Kanyinsola on 09/12/2019.
//  Copyright © 2019 Monnify. All rights reserved.
//

public let isLive = true

class Config {
    var environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    var baseUrl: String {
        return isLive ? environment.httpsBaseUrl : environment.httpsBaseUrl
    }
    
    var baseUrlWithVersion : String {
        return "\(baseUrl)/\(environment.version)"
    }
    
    var webSocketConnectionUrl: String {
        return isLive ? environment.webSocketHTTPSConnectionUrl : environment.webSocketHTTPSConnectionUrl
    }
}
