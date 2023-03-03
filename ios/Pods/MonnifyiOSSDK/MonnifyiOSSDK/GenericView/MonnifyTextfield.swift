//
//  MonnifyTextfield.swift
//  Monnify
//
//  Created by Kanyinsola on 06/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

@IBDesignable
class MonnifyTextfield: UIView {
    
    public var textChangedDelegate: MonnifyTextFieldDelegate?
    
    var text: String {
        return contentTextField.text ?? ""
    }
    
    @IBInspectable var numberOfDigit: Int = Int.max
    @IBInspectable var shouldContainOnlyDigit : Bool = false
    
    private let hintColor = UIColor.hintColor
    private let textBlack = UIColor.textBlack
    
    private var errorEnabled = false
    
    @IBInspectable var title: String? {
        set(value){contentTitle.text = value}
        get{return contentTitle.text}
    }
    
    @IBInspectable var placeholder: String?{
        set(value){contentTextField.placeholder = value}
        get{return contentTextField.placeholder}
    }
    
    @IBInspectable var isSecureTextEntry: Bool{
        set(value){contentTextField.isSecureTextEntry = value}
        get{return contentTextField.isSecureTextEntry}
    }
    
    @IBInspectable var rightImage : UIImage? {
        set(value){
            rightImageView.image = value
            rightButtonView.setImage(value, for: .normal)
        }
        get{return rightImageView.image}
    }
    
    @IBInspectable var rightPadding : CGFloat = 0
    @IBInspectable var leftPadding : CGFloat = 0
    
    lazy var contentTitle: UILabel = {
        let headerTitle = UILabel()
        headerTitle.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        headerTitle.textAlignment = .left
        headerTitle.textColor = hintColor
        return headerTitle
    }()
    
    lazy var contentTextField: UITextField =  {
        let textField = UITextField()
        guard let customFont = UIFont(name: "Inter-Regular", size: 13.0) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        textField.padding(left: self.leftPadding, right: self.rightPadding)
        textField.font = UIFontMetrics.default.scaledFont(for: customFont)
        textField.textColor = hintColor
        textField.delegate = self
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var rightImageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var rightButtonView: UIButton =  {
        let button = UIButton()
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))

        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
           setupView()
       }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
    func setText(_ text: String) {
        contentTextField.text = text
    }
    
    private func setupView() {
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadii
        self.layer.borderColor = viewBorderColor?.cgColor ?? UIColor.textFieldBorderColor.cgColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundColor = .white
        
        addSubview(contentTitle)
        addSubview(contentTextField)
        if rightImageView.image != nil {
            //addSubview(rightImageView)
            addSubview(rightButtonView)
        }
        
        let margin = self.layoutMarginsGuide
        
        contentTitle.translatesAutoresizingMaskIntoConstraints = false
        contentTitle.heightAnchor.constraint(equalToConstant: 14).isActive = true
        contentTitle.topAnchor.constraint(equalTo: margin.topAnchor, constant: 4).isActive = true
        contentTitle.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 12).isActive = true
        contentTitle.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        

        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentTextField.leftAnchor.constraint(equalTo: margin.leftAnchor, constant:  12).isActive = true
        contentTextField.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
        contentTextField.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true


        //
        //contentTextField.topAnchor.constraint(equalTo: contentTitle.bottomAnchor, constant: 2).isActive = true
        //contentTextField.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: 4).isActive = true
        
        if rightImageView.image != nil {
            //rightImageView.translatesAutoresizingMaskIntoConstraints = false
            //rightImageView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -rightPadding).isActive = true
            //rightImageView.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
            
            rightButtonView.translatesAutoresizingMaskIntoConstraints = false
            rightButtonView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -rightPadding).isActive = true
            rightButtonView.centerYAnchor.constraint(equalTo: margin.centerYAnchor).isActive = true
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveFocusToTextfield))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    @objc func moveFocusToTextfield() {
        contentTextField.becomeFirstResponder()
    }
    
    func setErrorEnabled(errorEnabled: Bool) {
        self.errorEnabled = errorEnabled
        updateColors(contentLength: contentTextField.text?.count ?? 0)
    }
    
    private func updateColors(contentLength: Int) {
        layer.borderColor = errorEnabled ? UIColor.desireRed.cgColor : UIColor.emeraldGreen.cgColor
        
        if contentLength == 0 {
            contentTextField.textColor = hintColor
        } else {
            contentTextField.textColor = errorEnabled ? UIColor.desireRed : textBlack
        }
    }
}

protocol MonnifyTextFieldDelegate {
    func textField(_ textField: MonnifyTextfield,
                       didChange text: String)
    
    func textFieldDidEndEditing(_ text: String)
}

extension MonnifyTextfield: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layer.borderColor = errorEnabled ? UIColor.desireRed.cgColor : UIColor.emeraldGreen.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderColor = errorEnabled ? UIColor.desireRed.cgColor : UIColor.textFieldBorderColor.cgColor
        textChangedDelegate?.textFieldDidEndEditing(textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if shouldContainOnlyDigit && !string.containsOnlyDigits() {
            return false
        }
            
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        updateColors(contentLength: updatedText.count)
        
        textChangedDelegate?.textField(self, didChange: updatedText )
        
        if updatedText.count > numberOfDigit {
            endEditing(false)
        }
        
        return numberOfDigit != Int.max ? updatedText.count <= numberOfDigit : true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
