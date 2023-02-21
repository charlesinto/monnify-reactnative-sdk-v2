//
//  PinView.swift
//  Monnify
//
//  Created by Kanyinsola on 06/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

@IBDesignable
class MonnifyPinView: UIView {
    
    var text: String = ""
    
    public var delegate: MonnifyPinViewDelegate?
    
    private var stackView: UIStackView!
    private var dotViews = [UIView]()
    private var currentIndex = 0
    
    @IBInspectable var numberOfDigit: Int = 4
    
    lazy var contentTextField: UITextField =  {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.isUserInteractionEnabled = true
        textField.tintColor = UIColor.clear
        textField.textColor = UIColor.clear
        return textField;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
        setupStackView()
    }
    
    private func setupView() {
        
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundColor = .white
        
        addSubview(contentTextField)
        
        let margin = self.layoutMarginsGuide
        
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        contentTextField.heightAnchor.constraint(equalTo: margin.heightAnchor).isActive = true
        contentTextField.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        contentTextField.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        contentTextField.topAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        contentTextField.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
    }
    
    private func setupStackView() {
                
        for index in 1...numberOfDigit/2 {
            let view = UIView()
            view.tag = index
            changeStyle(for: view, isFilled: false)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 12).isActive = true
            view.widthAnchor.constraint(equalToConstant: 12).isActive = true
            view.layer.cornerRadius =  6
            dotViews.append(view)
        }
        
        stackView = UIStackView(arrangedSubviews: dotViews)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        
        addSubview(stackView)
        
        let margin = self.layoutMarginsGuide
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        contentTextField.bringSubviewToFront(stackView)
        
        Logger.log("Stack View count \(stackView.arrangedSubviews.count)")
    }
    
    private func changeStyle(for view: UIView, isFilled: Bool){
        
        UIView.animate(withDuration: 0.1) {
            if isFilled {
                view.backgroundColor = UIColor.black
            } else {
                view.backgroundColor = UIColor.hintColor
            }
        }
    }
}

protocol MonnifyPinViewDelegate {
    func pinView(_ inputView: MonnifyPinView, didEnteredPin pin: String)
}

extension MonnifyPinView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layer.borderColor = UIColor.emeraldGreen.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderColor = UIColor.textFieldBorderColor.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count > numberOfDigit || !updatedText.containsOnlyDigits() { return false }
        
        let diff = updatedText.count - currentText.count
        
        if diff < 0 {
            currentIndex -= 1
            if currentIndex < numberOfDigit && currentIndex >= 0 {
                changeStyle(for: dotViews[currentIndex], isFilled: false)
            }
        } else {
            if currentIndex < numberOfDigit && currentIndex >= 0 {
                changeStyle(for: dotViews[currentIndex], isFilled: true)
            }
            currentIndex += 1
        }
        
        Logger.log("PIN VIEW shouldChangeCharactersIn \(updatedText)")
        
        self.text = updatedText
        
        if (text.count == numberOfDigit) {
            delegate?.pinView(self, didEnteredPin: text)
        }
        
        return true
    }
}
