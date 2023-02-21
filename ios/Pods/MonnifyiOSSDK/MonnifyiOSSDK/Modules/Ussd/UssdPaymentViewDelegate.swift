//
//  UssdPaymentViewDelegate.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 17/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol UssdPaymentViewDelegate : BaseView {
    
    func showLoading(text: String)
     
    func dismissLoading()
    
    func showUssdTransferDetails(viewModel: UssdPaymentDetailsViewModel)
}
