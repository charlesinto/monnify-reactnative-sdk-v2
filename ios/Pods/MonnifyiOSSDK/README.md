# Monnify iOS SDK

### Learn more

Learn more about the Monnify project [here](https://teamapt.com/monnify/).

## Getting Started

The Monnify iOS SDK allows you to accept payments from customers in your iOS application via the following ways
1. Card Payment
2. Bank Transfer / USSD Code
3. Direct Debit
4. Phone Number Transfer

[![Version](https://img.shields.io/cocoapods/v/monnify-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/monnify-ios-sdk)
[![License](https://img.shields.io/cocoapods/l/monnify-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/monnify-ios-sdk)
[![Platform](https://img.shields.io/cocoapods/p/monnify-ios-sdk.svg?style=flat)](https://cocoapods.org/pods/monnify-ios-sdk)

## Installation

MonnifyiOSSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MonnifyiOSSDK'
```

### 2. Access an instance of the Monnify SDK

```swift
let monnify = Monnify.shared
```

### 3. Set your merchant API key and contract code.
This should be done in your `AppDelegate.swift` file.
This should only be done once in the entire application.

```swift
let apiKey = "MK_PROD_XXXXXXXX"
let contractCode = "1234567890" 

monnify.setApiKey(apiKey: apiKey)
monnify.setContractCode(contractCode: contractCode)
```
### 4. Set application mode. 
This can be TEST or LIVE. The TEST mode works on a sandbox environment and payment can be simulated 
[here](https://websim.sdk.monnify.com/#/bankingapp). Remember to switch to ApplicationMode.live when generating 
live builds for your application on production.

```swift
let mode = ApplicationMode.test
monnify.setApplicationMode(applicationMode: mode)
```
### 5. Specify the transaction parameters as shown below:

```swift
let amount = Decimal(100)

let paymentRef = "ASDF123454321"

let parameter = TransactionParameters(amount: amount,
                                      currencyCode: "NGN",
                                      paymentReference: paymentRef,
                                      customerEmail: "johndoe@example.com",
                                      customerName: "John Doe" ,
                                      customerMobileNumber: "08000000000",
                                      paymentDescription: "Payment Description.",
                                      incomeSplitConfig: [],
                                      tokeniseCard: false)
```

### 6. Launch the payment gateway, perhaps when user clicks on a 'Pay' button. 
The initializePayment() method requires the following:

    * View Controller instance.
    
    * An instance of TransactionParameters, e.g `parameter` above.
    
    * A completion/callback to be called with the monnify sdk is completing either after a failure or success. 
    
```swift
monnify.initializePayment(withTransactionParameters: parameter,
                          presentingViewController: self,
                          onTransactionSuccessful: { result in
                          
    print(" Result \(result) ")
})
```


### 7. Get outcome of the payment attempt. The result is available via the callback registered in `initializePayment()` as describe above.


```swift
For example you can access the transaction status from the result as shown below.

let transactionStatus = result.transactionStatus

```
## Author

Kanyinsola Fapohunda,kanyinsola.fapohunda@teamapt.com
Nnaemeka Abah, nnaemeka.abah@teamapt.com

## License

Monnify is available under the MIT license. See the LICENSE file for more info.
