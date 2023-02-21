//
//  BankTransferDetailsViewDelegate.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 23/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol BankTransferDetailsViewDelegate : BaseView {
    
    func showLoading(text: String)
     
    func dismissLoading()
    
    func showBankTransferDetails(viewModel: BankTransferDetailsViewModel)
    
    func showOTPScreen(viewModel: EnterOTPViewModel)
    
    func updateAccountDetails(accountName: String)
    
    func getViewModel() -> BankTransferDetailsViewModel
    
    func hideAccountDetails()
}
