//
//  Secure3DAuthenticationViewDelegate.swift
//  Monnify
//
//  Created by Kanyinsola on 14/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

protocol Secure3DAuthenticationViewDelegate : BaseActiveViewDelegate {
    
    func showLoading(text: String)
      
    func dismissLoading()
}
