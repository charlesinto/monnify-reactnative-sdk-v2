//
//  ApiService.swift
//  SaveAll
//
//  Created by Kanyinsola on 21/08/2018.
//  Copyright © 2018 Crevance Savers. All rights reserved.
//

import Foundation

class ApiService: ApiServiceProtocol {
    
    static let shared = ApiService()
    
    func initializeTransaction(request: InitializeTransactionRequest,
                               completion: @escaping (MonnifyResponse<InitializeTransactionResponseBody>?, Error?) -> Void) {
        
        Network.shared.request(ApiEndPoints.shared.initTransaction(),
                               method: .post,
                               parameters: request.toDictionary(),
            successCompletion: { (json) in
                completion( MonnifyResponse<InitializeTransactionResponseBody>(json), nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func initializeAccountTransferPayment(request: InitializeAccountTransferRequest,
                                       completion: @escaping (MonnifyResponse<InitializeAccountTransferResponseBody>?, Error?) -> Void) {
        
        Network.shared.request(ApiEndPoints.shared.initAccountTransfer(),
                               method: .post,
                               parameters: request.toDictionary(),
            successCompletion: { (json) in
                completion( MonnifyResponse<InitializeAccountTransferResponseBody>(json), nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func initializeBankTransferPayment(request: InitializeBankTransferRequest,
                                       completion: @escaping (MonnifyResponse<InitializeBankTransferResponseBody>?, Error?) -> Void) {
        
        Network.shared.request(ApiEndPoints.shared.initBankTransfer(),
                               method: .post,
                               parameters: request.toDictionary(),
            successCompletion: { (json) in
                completion( MonnifyResponse<InitializeBankTransferResponseBody>(json), nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func initializePhoneTransferPayment(request: InitializePhoneTransferRequest,
                                       completion: @escaping (MonnifyResponse<InitializePhoneTransferResponseBody>?, Error?) -> Void) {
        
        Network.shared.request(ApiEndPoints.shared.initPhoneTransfer(),
                               method: .post,
                               parameters: request.toDictionary(),
            successCompletion: { (json) in
                completion( MonnifyResponse<InitializePhoneTransferResponseBody>(json), nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func initializeCardPayment(request: InitializeCardPaymentRequest,
                               completion: @escaping (MonnifyResponse<InitializeCardPaymentResponseBody>?, Error?) -> Void) {
        
        
               Network.shared.request(ApiEndPoints.shared.initCardPayment(),
                                      method: .post,
                                      parameters: request.toDictionary(),
                   successCompletion: { (json) in
                       completion( MonnifyResponse<InitializeCardPaymentResponseBody>(json), nil)
               }) { (error) in
                   completion(nil, error)
               }
    }
    
    func getCardRequirements(request: CardRequirementRequest,
                             completion: @escaping (MonnifyResponse<CardRequirementsResponseBody>?, Error?) -> Void) {
        
        Network.shared.request(ApiEndPoints.shared.cardsRequirements(),
                                          method: .post,
                               parameters: request.toDictionary(),
                       successCompletion: { (json) in
                           completion( MonnifyResponse<CardRequirementsResponseBody>(json), nil)
                   }) { (error) in
                       completion(nil, error)
                   }
    }
    
    func payWithCard(request: CardPaymentRequest, completion: @escaping (MonnifyResponse<CardPaymentResponseBody>?, Error?) -> Void) {
        
        Network.shared.request(ApiEndPoints.shared.payCard(),
                                           method: .post,
                                           parameters: request.toDictionary(),
                        successCompletion: { (json) in
                            completion( MonnifyResponse<CardPaymentResponseBody>(json), nil)
                    }) { (error) in
                        completion(nil, error)
                    }
    }
    
    func authorizeCardOtp(request: AuthorizeCardOtpRequest,
                          completion: @escaping (MonnifyResponse<CardPaymentResponseBody>?, Error?) -> Void) {
        
        Network.shared.request(ApiEndPoints.shared.authorizeCardOTP(),
                                                 method: .post,
                                                 parameters: request.toDictionary(),
                              successCompletion: { (json) in
                                  completion( MonnifyResponse<CardPaymentResponseBody>(json), nil)
                          }) { (error) in
                              completion(nil, error)
                          }
    }
    
    func authorize3DSecure(request: AuthorizeSecure3DSecureRequest,
                           completion: @escaping (MonnifyResponse<CardPaymentResponseBody>?, Error?) -> Void) {
        
        Network.shared.request(ApiEndPoints.shared.authorize3DSecure(),
                                                        method: .post,
                                                        parameters: request.toDictionary(),
                                     successCompletion: { (json) in
                                         completion( MonnifyResponse<CardPaymentResponseBody>(json), nil)
                                 }) { (error) in
                                     completion(nil, error)
                                 }

    }
    
    func checkTransactionStatus(apiKey: String,
                                transactionReference: String,
                                completion: @escaping (MonnifyResponse<TransactionStatusResponseBody>?, Error?) -> Void) {
        
        Network.shared.request( ApiEndPoints.shared.checkTransactionStatus(apiKey, transactionReference),
                                successCompletion: { (json) in
                                                completion( MonnifyResponse<TransactionStatusResponseBody>(json), nil)
                                        }) { (error) in
                                            completion(nil, error)
        }
    }
    
   
    
    func getAllBanks(completion: @escaping (MonnifyResponse<AllBanksResponse>? , Error?) -> Void) {
        
     Network.shared.request( ApiEndPoints.shared.allBanks(),
                             successCompletion: { (json) in
                                             completion( MonnifyResponse<AllBanksResponse>(json), nil)
                                     }) { (error) in
                                         completion(nil, error)
        }
    }
    
    func getProviderBanks(completion: @escaping (MonnifyResponse<ProviderBanksResponse>? , Error?) -> Void) {
        
     Network.shared.request( ApiEndPoints.shared.providerBanks(),
                             successCompletion: { (json) in
                                             completion( MonnifyResponse<ProviderBanksResponse>(json), nil)
                                     }) { (error) in
                                         completion(nil, error)
        }
    }
    
    func initializeUssdPayment(request: InitializeUssdPaymentRequest,
                               completion: @escaping (MonnifyResponse<InitializeUssdPaymentResponseBody>? , Error?) -> Void) {
        Network.shared.request(ApiEndPoints.shared.initUssdPayment(),
                               method: .post,
                               parameters: request.toDictionary(),
            successCompletion: { (json) in
                completion( MonnifyResponse<InitializeUssdPaymentResponseBody>(json), nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func getAccountDetails(request: GetAccountDetailsRequest,
                               completion: @escaping (MonnifyResponse<GetAccountDetailsResponseBody>? , Error?) -> Void) {
        Network.shared.request(ApiEndPoints.shared.getAccountDetails(),
                               method: .post,
                               parameters: request.toDictionary(),
            successCompletion: { (json) in
                completion( MonnifyResponse<GetAccountDetailsResponseBody>(json), nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func chargeAccount(request: ChargeAccountRequest,
                               completion: @escaping (MonnifyResponse<ChargeAccountResponseBody>? , Error?) -> Void) {
        Network.shared.request(ApiEndPoints.shared.chargeAccount(),
                               method: .post,
                               parameters: request.toDictionary(),
            successCompletion: { (json) in
                completion( MonnifyResponse<ChargeAccountResponseBody>(json), nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func authorizeBankOTP(request: AuthorizeBankOtpRequest,
                               completion: @escaping (MonnifyResponse<AuthorizeBankOTPResponseBody>? , Error?) -> Void) {
        Network.shared.request(ApiEndPoints.shared.authorizeBankOTP(),
                               method: .post,
                               parameters: request.toDictionary(),
            successCompletion: { (json) in
                completion( MonnifyResponse<AuthorizeBankOTPResponseBody>(json), nil)
        }) { (error) in
            completion(nil, error)
        }
    }

}
