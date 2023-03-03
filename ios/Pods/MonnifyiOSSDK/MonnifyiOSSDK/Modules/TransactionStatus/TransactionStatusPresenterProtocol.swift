//
//  TransactionStatusPresenterProtocol.swift
//  Monnify
//
//  Created by Kanyinsola on 15/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol TransactionStatusPresenterProtocol: BasePresenter {
    func startTerminationCountDown()
}

class TransactionStatusPresenter: TransactionStatusPresenterProtocol {
    
    private var secondsLeft : Int = 60
    private var sdkTerminationTimer : Timer?
    
    private weak var view: TransactionStatusViewDelegate?
    
    required init(view: TransactionStatusViewDelegate) {
        self.view = view
    }
    
    func startTerminationCountDown() {
        
        sdkTerminationTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(timerFired),
                                                   userInfo: nil,
                                                   repeats: true)
        sdkTerminationTimer?.fire()
    }
    
    @objc private func timerFired() {
        
        if secondsLeft > 0 {
            secondsLeft -= 1
            
            let seconds = (secondsLeft % 3600) % 60
            
            let formattedTime = String(format: "Returning to merchant in %2d", seconds)
            
            self.view?.updateCountDownIndicator(withText: formattedTime)
            
        } else {
            stopTimer()
            self.view?.completeTransaction()
        }
    }
    
    fileprivate func stopTimer() {
        sdkTerminationTimer?.invalidate()
        sdkTerminationTimer = nil
    }
}
