//
//  AccountTransferPresenter.swift
//  Monnify
//
//  Created by Kanyinsola on 15/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol AccountTransferPresenterProtocol : BaseActivePresenterProtocol {
    
    func startTimer(countDownTimeInSeconds: Int)
    
    func startCopyPressedTimer()
}

class AccountTransferPresenter: BaseActivePresenter  {
    
    private weak var view: AccountTransferViewDelegate?
    private var apiService: ApiServiceProtocol
    
    fileprivate var transactionExpiryTimer : Timer?
    fileprivate var copyPressedTimer : Timer?
    fileprivate var secondsLeft : Int = 0
    fileprivate var accountExpiryDuration : Int = 0

    required init(view: AccountTransferViewDelegate,
                  apiService: ApiServiceProtocol) {
        self.apiService = apiService
        self.view = view
        super.init(view: view, apiService: apiService)
    }
    
    override func stopListening() {
        super.stopListening()
        
        stopTimer()
    }   
}

extension AccountTransferPresenter : AccountTransferPresenterProtocol {
    
    func startTimer(countDownTimeInSeconds: Int) {
        secondsLeft = countDownTimeInSeconds
        accountExpiryDuration = countDownTimeInSeconds
        transactionExpiryTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                      target: self,
                                                      selector: #selector(transactionExpiryTimerFired), userInfo: nil, repeats: true)
        transactionExpiryTimer?.fire()
    }
    
    func startCopyPressedTimer() {
        var secondsPassed : Int = 0
        let totalSeconds : Int = 1
        copyPressedTimer?.invalidate()
        self.view?.updateCopyIcon(showCopied: true)
        copyPressedTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
               if secondsPassed < totalSeconds {
                   secondsPassed += 1
                   
               } else {
                   self.view?.updateCopyIcon(showCopied: false)
                   Timer.invalidate()
               }
           }
    }
    
    @objc private func transactionExpiryTimerFired() {
        
        if secondsLeft > 0 {
            secondsLeft -= 1
            let hours = secondsLeft / 3600
            let minutes = (secondsLeft % 3600) / 60
            let seconds = (secondsLeft % 3600) % 60
            
            let hourText = hours >  1 ? "hours" : "hour"
            let minuteText = minutes >  1 ? "mins" : "min"
            let secondText = seconds >  1 ? "secs" : "sec"
            
            var formattedTime = ""
            
            if hours == 0 {
                formattedTime = String(format: "Account expires in %02d \(minuteText) %02d \(secondText)", minutes, seconds)
            } else {
                formattedTime = String(format: "Account expires in %02d \(hourText)  %02d \(minuteText) %02d \(secondText)", hours, minutes, seconds)
            }
            
            let progress = (1.0 - Float(secondsLeft) / Float(accountExpiryDuration))
            
            self.view?.updateCountDownIndicator(withText: formattedTime, progress)
        } else {
            stopListening()
            isTransactionComplete = true
            
            view?.showLoading(text: StringLiterals.PleaseWait)
            verifyTransactionStatus { transaction in
                self.view?.dismissLoading()
                
                self.handleResponse(transaction, Monnify.shared.metadata, true)
                // Do clean ups.  nothing to think off for now.
            }
        }
    }

    private func stopTimer() {
        transactionExpiryTimer?.invalidate()
        copyPressedTimer?.invalidate()
        transactionExpiryTimer = nil
        copyPressedTimer = nil
    }
    
}
