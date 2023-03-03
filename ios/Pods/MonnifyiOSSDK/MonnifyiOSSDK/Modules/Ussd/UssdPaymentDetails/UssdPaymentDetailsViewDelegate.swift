//
//  UssdPaymentDetailsViewDelegate.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 23/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol UssdPaymentDetailsViewDelegate : BaseActiveViewDelegate {
    
    func showLoading(text: String)
     
    func dismissLoading()
    
    func updateCopyIcon(showCopied: Bool)

}
