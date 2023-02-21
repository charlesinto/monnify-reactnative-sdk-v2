//
//  ExpiryDateTextfield.swift
//  Monnify
//
//  Created by Kanyinsola on 07/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

class ExpiryDateTextfield: MonnifyTextfield {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func textField(_ textField: UITextField,
                            shouldChangeCharactersIn range: NSRange,
                            replacementString string: String) -> Bool {
                
        _ = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        var index = range.lowerBound
        let text = textField.text!
        
        if text.count == 2 && string == "/" {
            return true
        }
        
        if !string.containsOnlyDigits() {
            return false
        }
        
        if string == "" {
            var array = Array(text)
            array.remove(at: index)
            if array.count > 2 {
                if !array.contains("/"){
                    array.insert("/", at: 2)
                }
            }
            
            textField.text = String(array)
            let cursorPosition = textField.position(from: textField.beginningOfDocument, offset: index)!
            textField.selectedTextRange = textField.textRange(from: cursorPosition, to: cursorPosition)
        } else {
            let expiry = text.replacingOccurrences(of: "/", with: "")
            if text != expiry {
                if index > 1 {
                    index = range.lowerBound - 1
                }
            }
            
            var array = Array(expiry)
            if array.count < 4 {
                Logger.log("index: \(index) - \(array)")
                let newChar = Character(string)
                array.insert(newChar, at: index)
                Logger.log("new array: ", array)
                if array.count > 2 {
                    array.insert("/", at: 2)
                }
                
                if array.count == 1 && array[0] > "1" && array[0] <= "9" {
                    array.insert("0", at: 0)
                    index += 1
                }
                
                textField.text = String(array)
                index =  index > 1 ? index + 2 : index + 1
                let cursorPosition = textField.position(from: textField.beginningOfDocument, offset: index)!
                textField.selectedTextRange = textField.textRange(from: cursorPosition, to: cursorPosition)
            }
            Logger.log("Array \(array)")
        }
        
        validateInput()
        
        return false
    }
    
    private func validateInput() {
        
        let text = contentTextField.text ?? ""

        let validationState = CardValidator.shared.validationState(forExpiryDate: text)
        
        if validationState == .invalid {
            setErrorEnabled(errorEnabled: true)
        } else {
            setErrorEnabled(errorEnabled: false)
        }
        
    }
}
