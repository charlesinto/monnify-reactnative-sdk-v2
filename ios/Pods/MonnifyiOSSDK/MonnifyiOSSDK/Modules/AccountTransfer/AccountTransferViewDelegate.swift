//
//  AccountTransferViewDelegate.swift
//  Monnify
//
//  Created by Kanyinsola on 15/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol AccountTransferViewDelegate : BaseActiveViewDelegate {
    
    func showLoading(text: String)
     
    func dismissLoading()
    
    func updateCountDownIndicator(withText text: String,_ progress: Float)
    
    func updateCopyIcon(showCopied: Bool)
    
}
