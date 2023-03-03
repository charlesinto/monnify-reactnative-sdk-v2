//
//  File.swift
//  MonnifyReactNativeV2
//
//  Created by Charles Onuorah on 03/03/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import MonnifyiOSSDK
import UIKit

@objc(MonnifyReactNativeV2)
class MonnifyReactNativeV2: NSObject {
  let PAYMENT_INITIALIZATION_ERROR_CODE = "EIOS001"
  @objc(initialize:)
  public func initialize(_ options: NSDictionary) {

    if let dict = options as? [String: Any] {
        let apiKey = (dict["apiKey"] as? String) ?? ""
        let contractCode = (dict["contractCode"] as? String) ?? ""
        let applicationMode = (dict["applicationMode"] as? String) ?? "TEST"
        Monnify.shared.setApiKey(apiKey: apiKey)
        Monnify.shared.setContractCode(contractCode: contractCode)
        if applicationMode=="TEST" {
            Monnify.shared.setApplicationMode(applicationMode: ApplicationMode.test)
        } else if applicationMode=="LIVE" {
            Monnify.shared.setApplicationMode(applicationMode: ApplicationMode.live)
        }
    }

  }

  @objc(initializePayment::rejecter:)
  public func initializePayment(
    _ options: NSDictionary, _ resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: RCTPromiseRejectBlock
  ) {
    if let dict = options as? [String: Any] {
        if dict["amount"] == nil {
            reject(PAYMENT_INITIALIZATION_ERROR_CODE,"Amount cannot be empty", nil)

        }
        if dict["paymentReference"] == nil {
            reject(PAYMENT_INITIALIZATION_ERROR_CODE,"paymentReference cannot be empty", nil)

        }
        if dict["customerEmail"] == nil {
            reject(PAYMENT_INITIALIZATION_ERROR_CODE,"customerEmail cannot be empty", nil)

        }
        var incomeSplitConfig: [SubAccountDetails]
        if dict["incomeSplitConfig"] == nil {
            incomeSplitConfig = []
        } else {
            let incomeSplitConfigDictionary = dict["incomeSplitConfig"] as! [[String: Any]]
            incomeSplitConfig = incomeSplitConfigDictionary.map {
                SubAccountDetails.init(subAccountCode: ($0["subAccountCode"] as? String) ?? "",
                                       feePercentage: $0["feePercentage"] as? Float,
                                       splitAmount: Decimal.init(($0["splitAmount"] as? Double) ?? 0),
                                       feeBearer: $0["feeBearer"] as? Bool)
            }
        }

        var paymentMethods: [PaymentMethod] = []
        if dict["paymentMethods"] == nil {
            paymentMethods = [PaymentMethod.accountTransfer, PaymentMethod.card]
        } else {
            let paymentMethodsArray = dict["paymentMethods"] as! [String]
            for paymentMethod in paymentMethodsArray {
                if paymentMethod=="ACCOUNT_TRANSFER" {
                    paymentMethods.append(PaymentMethod.accountTransfer)
                } else if paymentMethod=="CARD"{
                    paymentMethods.append(PaymentMethod.card)
                }
            }
        }

        var metaData: [String:String] = [:]
        if dict["metadata"] != nil {
            for (key, value) in dict["metadata"] as! [String:Any] {
                metaData[key]=String(describing: value)
            }
        }
      let parameter = TransactionParameters(
        amount: Decimal.init((dict["amount"] as? Double) ?? 0),
        currencyCode: (dict["currencyCode"] as? String) ?? "NGN",
        paymentReference: (dict["paymentReference"] as? String) ?? "",
        customerEmail: (dict["customerEmail"] as? String) ?? "",
        customerName: (dict["customerName"] as? String) ?? "",
        customerMobileNumber: (dict["customerMobileNumber"] as? String) ?? "",
        paymentDescription: (dict["paymentDescription"] as? String) ?? "",
        incomeSplitConfig: incomeSplitConfig,
        metaData: metaData,
        paymentMethods: paymentMethods,
        tokeniseCard: (dict["tokeniseCard"] as? Bool) ?? false)
      DispatchQueue.main.sync {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
          Monnify.shared.initializePayment(
            withTransactionParameters: parameter,
            presentingViewController: rootViewController,
            onTransactionSuccessful: { result in
              let response: [String: Any] = [
                "transactionReference": result.transactionReference as Any,
                "transactionStatus": result.transactionStatus.rawValue,
                "paymentReference": result.paymentReference as Any,
                "paymentMethod": result.paymentMethod?.rawValue as Any,
                "amountPaid": result.amountPaid as Any,
                "amountPayable": result.amountPayable as Any,
              ]
              resolve(response)
            })

        }

      }
    }

  }

}
