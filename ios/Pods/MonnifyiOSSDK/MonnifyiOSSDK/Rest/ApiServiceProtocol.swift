//
//  ApiServiceProtocol.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol ApiServiceProtocol {
    
    func initializeTransaction(request: InitializeTransactionRequest,
                               completion: @escaping (_ response: MonnifyResponse<InitializeTransactionResponseBody>?, Error? ) -> Void)

    func initializeUssdPayment(request: InitializeUssdPaymentRequest,
                               completion: @escaping (MonnifyResponse<InitializeUssdPaymentResponseBody>? , Error?) -> Void)
    
    func initializeAccountTransferPayment(request: InitializeAccountTransferRequest,
                                       completion: @escaping (_ response: MonnifyResponse<InitializeAccountTransferResponseBody>?, Error? ) -> Void)
    
    func initializeBankTransferPayment(request: InitializeBankTransferRequest,
                                       completion: @escaping (_ response: MonnifyResponse<InitializeBankTransferResponseBody>?, Error? ) -> Void)
    
    func initializePhoneTransferPayment(request: InitializePhoneTransferRequest,
                                       completion: @escaping (_ response: MonnifyResponse<InitializePhoneTransferResponseBody>?, Error? ) -> Void)
    
    func initializeCardPayment(request: InitializeCardPaymentRequest,
                               completion: @escaping (_ response: MonnifyResponse<InitializeCardPaymentResponseBody>? , Error?) -> Void)
    
    func getCardRequirements(request: CardRequirementRequest,
                             completion: @escaping (_ response: MonnifyResponse<CardRequirementsResponseBody>?, Error? ) -> Void)
    
    func payWithCard(request: CardPaymentRequest,
                     completion: @escaping (_ response: MonnifyResponse<CardPaymentResponseBody>? , Error?) -> Void)
    
    func authorizeCardOtp(request: AuthorizeCardOtpRequest,
                          completion: @escaping (_ response: MonnifyResponse<CardPaymentResponseBody>?, Error? ) -> Void)

    func authorize3DSecure(request: AuthorizeSecure3DSecureRequest,
                           completion: @escaping (_ response: MonnifyResponse<CardPaymentResponseBody>? , Error?) -> Void)
    
    func checkTransactionStatus(apiKey: String,
                                transactionReference: String,
                                completion: @escaping (_ response: MonnifyResponse<TransactionStatusResponseBody>? , Error?) -> Void)
    
    
    func getAllBanks(completion: @escaping (MonnifyResponse<AllBanksResponse>? , Error?) -> Void)
    
    func getProviderBanks(completion: @escaping (MonnifyResponse<ProviderBanksResponse>? , Error?) -> Void)

    func getAccountDetails(request: GetAccountDetailsRequest,
                           completion: @escaping (MonnifyResponse<GetAccountDetailsResponseBody>?, Error?) -> Void)
    
    func chargeAccount(request: ChargeAccountRequest, completion: @escaping (MonnifyResponse<ChargeAccountResponseBody>?, Error?) -> Void)
    
    func authorizeBankOTP(request: AuthorizeBankOtpRequest, completion: @escaping (MonnifyResponse<AuthorizeBankOTPResponseBody>?, Error?) -> Void)
    
}
