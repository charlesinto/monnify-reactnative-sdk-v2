//
//  PaymentMethodPresenter.swift
//  Monnify
//
//  Created by Kanyinsola on 11/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import SwiftyJSON

protocol PaymentMethodPresenterProtocol : BasePresenter {
    
    func initializeCardPayment()
    
    func initializeAccountTransfer()
    
    func initializeUssdPayment()
    
    func initializePhoneTransfer()
    
    func initializeBankTransfer()
}

class PaymentMethodPresenter : PaymentMethodPresenterProtocol {
    
    private weak var view: PaymentMethodViewDelegate?
    private let apiService: ApiServiceProtocol
    private var preferenceManager: PreferenceManager
    
    required init(view: PaymentMethodViewDelegate,
                  apiService: ApiServiceProtocol,
                  preferenceManager: PreferenceManager) {
        self.apiService = apiService
        self.view = view
        self.preferenceManager = preferenceManager
    }
    
    func initializeCardPayment() {
        let monnify = Monnify.shared
        let request = InitializeCardPaymentRequest(
            transactionReference: monnify.transactionResult.transactionReference,
            apiKey: monnify.getApiKey())
        let currencyCode = monnify.metadata.currencyCode
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
        apiService.initializeCardPayment(request: request) { [weak self] (response, _) in

            guard let self = self else { return }

            self.view?.dismissLoading()
            
            guard let response = response else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: StringLiterals.GenericNetworkError)
                return
            }
            
            guard response.isSuccessful, let transaction = response.responseBody else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: response.responseMessage
                                            ?? "An unexpected error occurred please contact support.")
                return
            }
            
            let totalAmountPayable = transaction.totalAmountPayable.commaSeparatedNairaValue(currencyCode: currencyCode)
            let fee = (transaction.totalAmountPayable - transaction.amount).commaSeparatedNairaValue(currencyCode: currencyCode)
            let amountPayable = transaction.amount.commaSeparatedNairaValue(currencyCode: currencyCode)
            let feeDescription = fee // String(format: StringLiterals.TransactionFeeFormat, fee) 
            
            let metadata = Monnify.shared.metadata
            
            let cardVM = CardPaymentViewModel(
                merchantName: metadata?.merchantName ?? "NA",
                customerEmail: metadata?.customerEmail ?? "NA",
                merchantLogoUrl: metadata?.merchantLogoUrl,
                totalPayable: totalAmountPayable,
                amountPayable: amountPayable,
                fee: feeDescription,
                totalPayableAmount: transaction.totalAmountPayable
            )
            
            self.view?.showCardPayment(viewModel: cardVM)
        }
    }
    
    func initializeAccountTransfer() {
        
        let monnify = Monnify.shared
        let request = InitializeAccountTransferRequest(
            transactionReference: monnify.transactionResult.transactionReference,
            apiKey: monnify.getApiKey())
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
        apiService.initializeAccountTransferPayment(request: request) { [weak self] (response, _) in
           
            guard let self = self else { return }

            self.view?.dismissLoading()
            
            guard let response = response else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: StringLiterals.GenericNetworkError)
                return
            }
            
            guard response.isSuccessful, let transaction = response.responseBody else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: response.responseMessage
                                            ?? "An unexpected error occurred please contact support.")
                return
            }
            
            self.loadAndPersistBanks { [weak self] (banks) in
                
                guard let self = self else { return }

                self.showAccountTransferScreen(transaction,
                                               banks)
            }
            
        }
    }
    
    func initializeBankTransfer() {
        
        let monnify = Monnify.shared
        let request = InitializeBankTransferRequest(
            transactionReference: monnify.transactionResult.transactionReference,
            apiKey: monnify.getApiKey())
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
        apiService.initializeBankTransferPayment(request: request) { [weak self] (response, _) in
           
            guard let self = self else { return }

            self.view?.dismissLoading()
            
            guard let response = response else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: StringLiterals.GenericNetworkError)
                return
            }
            
            guard response.isSuccessful, let transaction = response.responseBody else {
                self.view?.showAlertDialog(title: StringLiterals.ErrorOccured,
                                           message: response.responseMessage
                                            ?? "An unexpected error occurred please contact support.")
                return
            }
            
            self.loadAndPersistProviderBanks { [weak self] (banks) in
                
                guard let self = self else { return }

                self.showBankTransferScreen(transaction,
                                               banks)
            }
            
        }
    }
    
    func initializeUssdPayment() {
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
        self.loadAndPersistBanks { [weak self] (banks) in
            
            guard let self = self else { return }

            self.showUssdTransferScreen(banks)
    }
        
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        
    }
    
    func initializePhoneTransfer() {
        self.showPhoneTransferScreen()
    }
    
    private func showPhoneTransferScreen() {
        let monnify = Monnify.shared
        
        let viewModel = self.view?.getViewModel()
        
        let totalAmountPayable = viewModel!.totalPayable
        
        let metadata = monnify.metadata
        
        let phoneTransferVM = PhoneTransferViewModel(merchantName: metadata?.merchantName ?? "NA",
                                                 customerEmail: metadata?.customerEmail ?? "NA",
                                                 merchantLogoUrl: metadata?.merchantLogoUrl,
                                                     totalPayable: totalAmountPayable, fee: 0.00.commaSeparatedNairaValue(currencyCode: metadata!.currencyCode))
        self.view?.showPhoneTransferPayment(viewModel: phoneTransferVM)
    }
    
    private func showUssdTransferScreen(_ banks: [Bank]) {
        let monnify = Monnify.shared
        //let currencyCode = monnify.metadata.currencyCode
        
        let viewModel = self.view?.getViewModel()
        
        let totalAmountPayable = viewModel!.totalPayable
        
        let metadata = monnify.metadata
        
        let ussdVM = UssdPaymentViewModel(banks: banks, merchantName: metadata?.merchantName ?? "NA",
                                          customerEmail: metadata?.customerEmail ?? "NA",
                                          merchantLogoUrl: metadata?.merchantLogoUrl,
                                          totalPayable: totalAmountPayable)
        
        self.view?.showUssdTransferPayment(viewModel: ussdVM)
    }
    
    private func showAccountTransferScreen(_ transaction: InitializeAccountTransferResponseBody,
                                           _ banks: [Bank]) {
        
        let monnify = Monnify.shared
        let currencyCode = monnify.metadata.currencyCode
        let itemValue = transaction.totalPayable.commaSeparatedNairaValue(currencyCode: currencyCode)
        let totalAmountPayable = (transaction.totalPayable + transaction.fee).commaSeparatedNairaValue(currencyCode: currencyCode)
        let fee = transaction.fee.commaSeparatedNairaValue(currencyCode: currencyCode)
        
        let metadata = monnify.metadata
        
        let accountVM = AccountTransferViewModel(
            bankName: transaction.bankName,
            accountNumber: transaction.accountNumber,
            accountName: transaction.accountName,
            accountDurationSeconds: transaction.accountDurationSeconds,
            banks: banks,
            merchantName: metadata?.merchantName ?? "NA",
            customerEmail: metadata?.customerEmail ?? "NA",
            merchantLogoUrl: metadata?.merchantLogoUrl,
            totalPayable: totalAmountPayable)
        
        self.view?.showAccountTransferPayment(viewModel: accountVM)
        
    }
    
    private func showBankTransferScreen(_ transaction: InitializeBankTransferResponseBody,
                                           _ banks: [Bank]) {
        
        let monnify = Monnify.shared
        let currencyCode = monnify.metadata.currencyCode
        let itemValue = transaction.amount.commaSeparatedNairaValue(currencyCode: currencyCode)
        let totalAmountPayable = transaction.totalAmountPayable.commaSeparatedNairaValue(currencyCode: currencyCode)
        let fee = transaction.paymentFee.commaSeparatedNairaValue(currencyCode: currencyCode)
        
        let metadata = monnify.metadata
        
        let bankVM = BankTransferViewModel(
            banks: banks,
            merchantName: metadata?.merchantName ?? "NA",
            customerEmail: metadata?.customerEmail ?? "NA",
            merchantLogoUrl: metadata?.merchantLogoUrl,
            totalPayable: totalAmountPayable,
            //itemValue: itemValue,
            fee: fee)
        
        self.view?.showBankTransferPayment(viewModel: bankVM)
        
    }
    
    private func loadAndPersistBanks(completion: @escaping (_ banks: [Bank]) -> Void) {
        
        let expiresIn = preferenceManager.readDouble(key: PersistenceIDs.BanksCacheExpiryTime)
        let expirationDate = Date(timeIntervalSince1970: expiresIn)
        
        if expirationDate > Date() {
            let banks = preferenceManager.getBanks()
            Logger.log("Banks: \(banks)")
            completion(banks)
            return
        }
        
        // if cached data has expired reload it.
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        apiService.getAllBanks { [weak self] (response, _) in
            
            guard let self = self else { return }

            self.view?.dismissLoading()
            
            guard let response = response, response.isSuccessful,
                let banksResponse = response.responseBody else {
                    completion([])
                    return
            }
            
            self.preferenceManager.persistBanksArray(banks: response.responseBody?.banks ?? [])
            self.updateBankCacheExpiryTime(key: PersistenceIDs.BanksCacheExpiryTime)
            completion(banksResponse.banks ?? [])
        }
    }
    
    private func loadAndPersistProviderBanks(completion: @escaping (_ banks: [Bank]) -> Void) {
        
        let expiresIn = preferenceManager.readDouble(key: PersistenceIDs.ProviderBanksCacheExpiryTime)
        let expirationDate = Date(timeIntervalSince1970: expiresIn)
        
        if expirationDate > Date() {
            let banks = preferenceManager.getProviderBanks()
            Logger.log("Provider Banks: \(banks)")
            completion(banks)
            return
        }
        
        // if cached data has expired reload it.
        
        view?.showLoading(text: StringLiterals.PleaseWait)
        apiService.getProviderBanks { [weak self] (response, _) in
            
            guard let self = self else { return }

            self.view?.dismissLoading()
            
            guard let response = response, response.isSuccessful,
                let banksResponse = response.responseBody else {
                    completion([])
                    return
            }
            
            self.preferenceManager.persistProviderBanksArray(banks: response.responseBody?.banks ?? [])
            self.updateBankCacheExpiryTime(key: PersistenceIDs.ProviderBanksCacheExpiryTime)
            completion(banksResponse.banks ?? [])
        }
    }
    
    private func updateBankCacheExpiryTime(key: String) {
        var components = DateComponents()
        components.setValue(2, for: .month)
        let expiresIn = Calendar.current.date(byAdding: components, to: Date())?.timeIntervalSince1970 ?? 0.0
        
        preferenceManager.persistDouble(value: expiresIn,
                                        key: key)
    }
}
