import Foundation

class ApiEndPoints : NSObject {
    
    private var config: Config
    static let shared = ApiEndPoints()
    
    private override init(){
        self.config = Config(environment: Monnify.shared.environment)
        super.init()
    }
    
    func initTransaction() -> String {
        return "\(config.baseUrlWithVersion)/transactions/init-transaction"
    }
    
    func initAccountTransfer() -> String {
        return "\(config.baseUrlWithVersion)/bank-transfer/init-payment"
    }
    
    func initCardPayment() -> String {
        return "\(config.baseUrlWithVersion)/cards/init-card-transaction"
    }
    
    func payCard() -> String {
        return "\(config.baseUrlWithVersion)/cards/charge"
    }
    
    func authorizeCardOTP() -> String {
        return "\(config.baseUrlWithVersion)/cards/otp/authorize"
    }
    
    func authorize3DSecure() -> String {
        return "\(config.baseUrlWithVersion)/cards/secure-3d/authorize"
    }
    
    func cardsRequirements() -> String {
        return "\(config.baseUrlWithVersion)/cards/requirements"
    }
    
    func allBanks() -> String {
        return "\(config.baseUrlWithVersion)/transactions/banks"
    }
    
    func providerBanks() -> String {
        return "\(config.baseUrlWithVersion)/bank/list-banks"
    }
    
    func checkTransactionStatus(_ apiKey: String, _ transactionReference: String) -> String {
        return "\(config.baseUrlWithVersion)/transactions/query/\(apiKey)?transactionReference=\(transactionReference)"
    }
    
    func checkBankTransactionStatus() -> String {
        return "\(config.baseUrlWithVersion)/bank/transaction-status"
    }
    
    func socketConnection() -> String {
        return "\(config.webSocketConnectionUrl)/websocket/v1/notification/subscribe/websocket"
    }
    
    func transactionSubscription(transactionRef: String) -> String {
        return "/transaction/\(transactionRef)"
    }
    
    func initUssdPayment() -> String {
        return "\(config.baseUrlWithVersion)/ussd/initialize"
    }
    
    func initBankTransfer() -> String {
        "\(config.baseUrlWithVersion)/bank/init-transaction"
    }
    
    func initPhoneTransfer() -> String {
        "\(config.baseUrlWithVersion)/phone-payment/initialize"
    }
    
    func getAccountDetails() -> String {
        "\(config.baseUrlWithVersion)/bank/verify"
    }
    
    func chargeAccount() -> String {
        "\(config.baseUrlWithVersion)/bank/charge"
    }
    
    func authorizeBankOTP() -> String {
        "\(config.baseUrlWithVersion)/bank/authorize/otp"
    }
    
    func confirmBankTransfer() -> String {
        "\(config.baseUrlWithVersion)/bank/transaction-status"
    }
}
