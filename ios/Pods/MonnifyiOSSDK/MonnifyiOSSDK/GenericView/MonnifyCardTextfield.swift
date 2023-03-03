//
//  MonnifyCardTextfield.swift
//  Monnify
//
//  Created by Kanyinsola on 07/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

class MonnifyCardTextfield: MonnifyTextfield {
    
    var delegate: MonnifyCardTextfieldDelegate?
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    private var maxLengthForCurrentBrand = 19
    private var currentMatchBrand = CardBrand.unknown
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        //rightImage = getImage(forBrand: .unknown)
        contentTextField.addTarget(self, action: #selector(reformatAsCardNumber(textField:)), for: .editingChanged)
        super.layoutSubviews()
    }
    
    @objc private func reformatAsCardNumber(textField: UITextField) {
        
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > maxLengthForCurrentBrand {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
        
        validateInput()
        updateCardImageAndSetCurrentExpectedLength()
    }
    
    private func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
   func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
    
          let is456 = string.hasPrefix("1")
          
          let is465 = [
              // Amex
              "34", "37",

              // Diners Club
              "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
          ].contains { string.hasPrefix($0) }
          
          let is4444 = !(is456 || is465)

          var stringWithAddedSpaces = ""
          let cursorPositionInSpacelessString = cursorPosition

          for i in 0..<string.count {
              let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
              let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
              let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)

              if needs465Spacing || needs456Spacing || needs4444Spacing {
                  stringWithAddedSpaces.append(" ")

                  if i < cursorPositionInSpacelessString {
                      cursorPosition += 1
                  }
              }

              let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
              stringWithAddedSpaces.append(characterToAdd)
          }

          return stringWithAddedSpaces
      }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        _ = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        previousTextFieldContent = textField.text
        previousSelection = textField.selectedTextRange
        
        return true
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)

        let cleanCardNumber = contentTextField.text?.cleanNumericString() ?? ""

        let cardNumberValidationState = CardValidator.shared.validationState(forCardWithNumber: cleanCardNumber)
        delegate?.cardTextfield(self, didChange: cleanCardNumber, cardNumberValidationState)
    }

    private func validateInput() {
                
        let cardNumberValidationState =
            CardValidator.shared.validationState(forCardWithNumber: contentTextField.text ?? "")
        
        switch cardNumberValidationState {
        case .invalid:
            setErrorEnabled(errorEnabled: true)
        default:
            setErrorEnabled(errorEnabled: false)
        }
    }
    
    private func updateCardImageAndSetCurrentExpectedLength() {
        
        let cleanCardNumber = contentTextField.text?.cleanNumericString() ?? ""
        
        let possibledBrands = CardValidator.shared.possibleBrands(
            forCardWithNumber: cleanCardNumber)
    
        if possibledBrands.contains(.verve) {
            maxLengthForCurrentBrand = 19
        } else {
            possibledBrands.forEach({ brand in
                let length = CardValidator.shared.lengthForCardBrand(brand: brand)
                maxLengthForCurrentBrand = min(maxLengthForCurrentBrand, length)
            })
        }
        
        var image = getImage(forBrand: .unknown)
        
        if possibledBrands.count == 1 {
            currentMatchBrand = possibledBrands.first!
            image = getImage(forBrand: possibledBrands.first!)
        } else {
            currentMatchBrand = .unknown
        }
        
        if rightImage != image {
            UIView.transition(with: rightImageView, duration: 0.5,
                              options: .transitionCrossDissolve, animations: {
                                self.rightImage = image
            }, completion: nil)
        }
    }
    
    func getImage(forBrand brand: CardBrand) -> UIImage? {
        
        switch brand {
        case .verve:
            return UIImage.initWithName("card_verve")
        case .mastercard:
            return UIImage.initWithName("card_mastercard")
        case .visa:
            return UIImage.initWithName("card_visa")
        default:
            return UIImage.initWithName("card_placeholder_template")
        }
    }
}

protocol MonnifyCardTextfieldDelegate {
    func cardTextfield(_ cardTextfield: MonnifyCardTextfield,
                       didChange cardNumber: String,
                       _ validationState: CardValidationState)
}
