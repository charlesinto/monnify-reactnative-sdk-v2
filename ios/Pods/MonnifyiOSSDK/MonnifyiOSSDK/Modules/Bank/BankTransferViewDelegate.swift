//
//  BankTransferViewDelegate.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 22/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol BankTransferViewDelegate : BaseView {
    
    func showLoading(text: String)
     
    func dismissLoading()
    
    func getViewModel() -> BankTransferViewModel

    func showBankTransferDetails(viewModel: BankTransferDetailsViewModel)
}
