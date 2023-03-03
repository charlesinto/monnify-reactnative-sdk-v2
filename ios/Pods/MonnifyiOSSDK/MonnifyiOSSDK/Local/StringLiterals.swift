import Foundation

struct StringLiterals {
    
    // Loading Indicator Messages
    static let PleaseWait =                   "Please Wait"
    static let VerifyingOTP =                 "Verifying OTP"
    static let Welcome =              "Welcome"
    static let CardInformation =              "Card Information"
    static let EnterOTP =                     "Enter OTP"
    static let AccountTransfer =              "Account Transfer"
    static let Secure3D =                     "Secure 3D"
    static let TransactionStatus =            "Transaction Status"


    // In app strings
    static let GenericNetworkError =          "An unexpected network error occurred. please ensure you have internet connection "
    static let ErrorOccured =                 "Error occured"
    static let Back =                         "Back"
    static let Continue =                     "Continue"
    static let Proceed =                      "Proceed"
    static let VerifyAccount =                "Verify account"
    static let InvalidInput =                 "Invalid Input"
    static let VerifyingTransactionStatus =   "Verifying transaction status"
    static let InitializingTransaction =      "Initializing transaction"
    static let InvalidCardPinMessage =        "Please enter the 4-digit pin of your card."
    static let InvalidCardEntry =             "Please enter a valid card information."
    static let InvalidExpiryDate =            "Please enter a valid expiry date."
    static let OTPCannotBeEmptyMessage =      "Please enter the otp sent to your phone."
    static let SystemError =                  "An unexpected error occurred, please contact support."

    static let Ok =                           "Ok"
    static let TransactionSuccessful =        "Transaction Successful!"
    static let TransactionSuccessfulDesc =    "Your payment of %@ was successful. We’ve sent a receipt of this transaction to your email."
    static let TransactionFeeFormat =         "Transaction Fee: %@"
    static let PartialPaymentDesc =           "Your partial payment of %s was successful. We’ve sent a receipt of this transaction to your email. You still have to pay %@ to complete this transaction."
     static let OverPaymentDesc =             "Your payment of %s was successful. We’ve sent a receipt of this transaction to your email. Your paid in excess of %s."
    static let OtpFailureDesc =                   "Invalid OTP Provided"
    static let TransactionFailed =            "Transaction Failed!"
    static let TransactionExpired =           "Transaction Expired!"
    static let TransactionPending =           "Transaction Pending!"
    static let TransactionPendingDesc =       "Couldn't verify payment for this transaction."
    static let TransactionFailedDesc =        "Transaction unable to be completed."
    static let TransactionExpiredDesc =       "Transaction expired because no payment was made on time."

    static let ValidatingOTPErrorMsg =        "Could to validate OTP. Please try again."

    static let Paid =                         "PAID"
    static let PartialPayment =               "PARTIALLY PAID"
    static let OverPayment =                  "OVERPAID"
    static let Total =                        "TOTAL"
}
