//
//  UITextField.swift
//  Monnify
//
//  Created by Kanyinsola on 06/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

extension UITextField {
    func padding(left:CGFloat, right: CGFloat){
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
        self.leftViewMode = .always
        
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
        self.rightViewMode = .always
    }
}
