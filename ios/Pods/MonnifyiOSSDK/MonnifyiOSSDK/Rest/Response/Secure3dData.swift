//
//  Secure3dData.swift
//  Monnify
//
//  Created by Kanyinsola on 12/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//
import SwiftyJSON

struct Secure3dData {
    
    let id: String
    let callBackUrl: String
    let method: String
    let redirectUrl: String
    let nacsUrl: String
    let eciFlag: String
    let md: String
    let paReq: String
    let paymentId: String
    let termUrl: String
    let transactionId: String

    init(_ json: JSON) {
        id = json["id"].stringValue
        callBackUrl = json["callBackUrl"].stringValue
        method = json["method"].string ?? "POST"
        redirectUrl = json["redirectUrl"].stringValue
        nacsUrl = json["nacsUrl"].stringValue
        eciFlag = json["eciFlag"].stringValue
        md = json["md"].stringValue
        paReq = json["paReq"].stringValue
        paymentId = json["paymentId"].stringValue
        termUrl = json["termUrl"].stringValue
        transactionId = json["transactionId"].stringValue
    }
    
    private func getIPGPOSTBody() -> Data? {
        
        let body = [
            "MD": md,
            "PaReq": paReq,
            "TermUrl": termUrl
        ]
        
        var data = [String]()
        for(key, value) in body {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&").data(using: .utf8)
    }
    
    func getPostBody() -> Data? {
        
        let provider = getProvider()
        
        if provider == .ipg {
            return getIPGPOSTBody()
        } else if provider == .payu {
            return "".data(using: .utf8)
        }
        
        return nil
    }
    
    func getProvider() -> CardProvider {
        
        if callBackUrl.contains("interswitchng") {
            return .ipg
        } else {
            return .payu
        }
    }
}
