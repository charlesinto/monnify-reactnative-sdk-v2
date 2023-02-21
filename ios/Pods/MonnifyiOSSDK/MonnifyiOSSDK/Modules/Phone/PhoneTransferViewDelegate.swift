//
//  PhoneTransferViewDelegate.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 06/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import Foundation

protocol PhoneTransferViewDelegate : BaseActiveViewDelegate {
    
    func showLoading(text: String)
     
    func dismissLoading()
        
    func getViewModel() -> PhoneTransferViewModel
    
}
