//
//  InitializedTransactionState.swift
//  Monnify
//
//  Created by Kanyinsola on 11/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

public class TransactionResult: CustomStringConvertible {
    
    // Default status is cancelled, this informs when the transaction is cancelled before it could be verified.
    public var transactionStatus: TransactionStatus = .cancelled
    public var transactionReference: String = ""
    public var paymentReference: String = ""
    public var paymentMethod: PaymentMethod?
    public var amountPaid: Decimal?
    public var amountPayable: Decimal?
    
    init() {}
    
    public var description: String {
        return """
        transactionStatus: \(String(describing: transactionStatus)),
        transactionReference: \(String(describing: transactionReference)),
        paymentMethod: \(String(describing: paymentMethod)),
        amountPaid: \(String(describing: amountPaid)),
        amountPayable: \(String(describing: amountPayable))
        """
    }
}
