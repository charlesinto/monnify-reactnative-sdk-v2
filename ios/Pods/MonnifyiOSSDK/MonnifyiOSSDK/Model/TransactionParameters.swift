//
//  TransactionParameters.swift
//  Monnify
//
//  Created by Kanyinsola on 28/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

public struct TransactionParameters {
    public let amount : Decimal
    public let currencyCode: String
    public let paymentReference: String
    public let customerEmail: String
    public let customerName: String?
    public let customerMobileNumber : String?
    public let paymentDescription: String?
    public let incomeSplitConfig: [SubAccountDetails]?
    public let metaData: [String: String]?
    public let paymentMethods: [PaymentMethod]?
    public let tokeniseCard: Bool?
    
    public init(amount : Decimal,
                currencyCode: String,
                paymentReference: String,
                customerEmail: String,
                customerName: String?,
                customerMobileNumber : String?,
                paymentDescription: String?,
                incomeSplitConfig: [SubAccountDetails]?,
                metaData: [String: String]?,
                paymentMethods: [PaymentMethod]?,
                tokeniseCard: Bool?) {
        
        self.amount = amount
        self.currencyCode = currencyCode
        self.paymentReference = paymentReference
        self.customerEmail = customerEmail
        self.customerName = customerName
        self.customerMobileNumber = customerMobileNumber
        self.paymentDescription = paymentDescription
        self.incomeSplitConfig = incomeSplitConfig
        self.metaData = metaData
        self.paymentMethods = paymentMethods
        self.tokeniseCard = tokeniseCard
    }
    
    func toInitializeTransactionRequest(contractCode: String?,
                                        apiKey: String?) -> InitializeTransactionRequest {
        
        let request = InitializeTransactionRequest(amount: amount,
                                                   customerName: customerName,
                                                   customerEmail: customerEmail,
                                                   paymentReference: paymentReference,
                                                   paymentDescription: paymentDescription,
                                                   currencyCode: currencyCode,
                                                   contractCode: contractCode,
                                                   apiKey: apiKey,
                                                   metaData: metaData,
                                                   paymentMethods: paymentMethods,
                                                   incomeSplitConfig: incomeSplitConfig)
        return request
    }
}
