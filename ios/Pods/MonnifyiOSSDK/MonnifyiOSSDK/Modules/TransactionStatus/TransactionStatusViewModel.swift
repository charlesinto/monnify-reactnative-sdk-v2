//
//  TransactionStatusViewModel.swift
//  Monnify
//
//  Created by Kanyinsola on 13/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

struct TransactionStatusViewModel {
    
    let merchantName: String
    let customerEmail: String
    let amountPaid: String
    let fee: String
    let itemValue: String
    let merchantLogoUrl: String?
    let statusTitle: String
    let title: String
    let description: String
    let image: UIImage?
    let shouldComplete: Bool
    
    static func create(_ transaction: TransactionStatusResponseBody,
                       _ metaData: TransactionMetaData, otpFailure: Bool = false) -> TransactionStatusViewModel {
        
        let transactionStatus = otpFailure ? .failed : TransactionStatus(rawValue: transaction.paymentStatus) ?? .pending
        let amountPaid = (transaction.amountPaid + transaction.fee).commaSeparatedNairaValue(currencyCode: metaData.currencyCode)
        let fee = transaction.fee.commaSeparatedNairaValue(currencyCode: metaData.currencyCode)
        let itemValue = transaction.amountPaid.commaSeparatedNairaValue(currencyCode: metaData.currencyCode)
        let title = otpFailure ? StringLiterals.TransactionFailed : getTitleFromPaymentStatus(status: transactionStatus)
        let description = otpFailure ? StringLiterals.OtpFailureDesc : getDescriptionFromPaymentStatus(status: transactionStatus,
                                                          amountPaid: transaction.amountPaid,
                                                          amountPayable: transaction.payableAmount,
                                                          metadata: metaData)
        let image = getImageForPaymentStatus(status: transactionStatus)
        let statusTitle = getStatusTitleForPaymentStatus(status: transactionStatus)
        
        let shouldComplete =
        metaData.paymentMethods.count == 1 || // Single payment method, can't try again with another payment method,
            transactionStatus == .paid ||
            transactionStatus == .pending ||
            transactionStatus == .partiallyPaid ||
            transactionStatus == .overpaid ||
            transactionStatus == .expired ||
            transactionStatus == .reversed
        
        return TransactionStatusViewModel(merchantName: metaData.merchantName,
                                          customerEmail: metaData.customerEmail,
                                          amountPaid: amountPaid,
                                          fee: fee,
                                          itemValue: itemValue,
                                          merchantLogoUrl: metaData.merchantLogoUrl,
                                          statusTitle: statusTitle,
                                          title: title,
                                          description: description,
                                          image: image,
                                          shouldComplete: shouldComplete)
    }
    
    static func getTitleFromPaymentStatus(status: TransactionStatus) -> String {
        
        switch status {
        case .paid, .pending, .overpaid, .partiallyPaid:
            return StringLiterals.TransactionSuccessful
        case .expired:
            return StringLiterals.TransactionExpired
        default:
            return StringLiterals.TransactionFailed
        }
    }
    
    static func getDescriptionFromPaymentStatus(status: TransactionStatus,
                                                amountPaid: Decimal,
                                                amountPayable: Decimal,
                                                metadata: TransactionMetaData) -> String {
        let amountStr = amountPaid.commaSeparatedNairaValue(currencyCode: metadata.currencyCode)
        
        switch status {
        case .paid:
            return String(format: StringLiterals.TransactionSuccessfulDesc,
                          amountStr)
        case .pending:
            return StringLiterals.TransactionPendingDesc
        case .partiallyPaid:
            let amountLeftStr = abs(amountPayable - amountPaid).commaSeparatedNairaValue(currencyCode: metadata.currencyCode)
            return String(format: StringLiterals.PartialPaymentDesc,
                          amountStr, amountLeftStr)
        case .overpaid:
            let excessAmountStr = abs(amountPayable - amountPaid).commaSeparatedNairaValue(currencyCode: metadata.currencyCode)
            return String(format: StringLiterals.OverPaymentDesc,
                          amountStr, excessAmountStr)
        case .expired:
            return StringLiterals.TransactionExpiredDesc
        default:
            return StringLiterals.TransactionFailedDesc
        }
    }
    
    static func getStatusTitleForPaymentStatus(status: TransactionStatus) -> String {
        
        switch status {
        case .paid:
            return StringLiterals.Paid
        case .partiallyPaid:
            return StringLiterals.PartialPayment
        case .overpaid:
            return StringLiterals.OverPayment
        default:
            return StringLiterals.Total
        }
    }
    
    static func getImageForPaymentStatus(status: TransactionStatus) -> UIImage? {
        
        switch status {
        case .paid:
            return UIImage.initWithName("ic_transaction_success")
        case .pending, .partiallyPaid, .overpaid:
            return UIImage.initWithName("ic_transaction_warning")
        default:
            return UIImage.initWithName("ic_transaction_failed")
        }
    }
}
