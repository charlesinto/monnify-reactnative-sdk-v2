//
//  Status.swift
//  Monnify
//
//  Created by Kanyinsola on 12/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

public enum TransactionStatus: String {
    case pending = "PENDING"
    case paid = "PAID"
    case overpaid = "OVERPAID"
    case partiallyPaid = "PARTIALLY_PAID"
    case cancelled = "CANCELLED"
    case reversed = "REVERSED"
    case expired = "EXPIRED"
    case failed = "FAILED"
}
