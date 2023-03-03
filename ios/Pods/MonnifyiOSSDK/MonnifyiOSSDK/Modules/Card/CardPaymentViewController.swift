//
//  CardPaymentViewController.swift
//  Monnify
//
//  Created by Kanyinsola on 06/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit
import EasyTipView

class CardPaymentViewController: BaseViewController {
    
    var viewModel: CardPaymentViewModel!
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var totalAmountPayableLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var cardNumberTextfield: MonnifyCardTextfield!
    @IBOutlet weak var expiryDataTextfield: ExpiryDateTextfield!
    @IBOutlet weak var cvvTextfield: MonnifyTextfield!
    @IBOutlet weak var pinView: MonnifyPinView!
    @IBOutlet weak var pinViewContainer: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var cardPaymentRootView: UIView!
    
    private var presenter: CardPaymentPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
#if DEBUG
        //        prefillFieldsMastercard()
#endif
    }
    
    private func setupView() {
        addTapGestureForCvvTooltip()
        
        title = StringLiterals.CardInformation
        setupNextButton()
        
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        totalAmountPayableLabel.text = viewModel.totalPayable
        amountPayableLabel.text = viewModel.amountPayable
        feePayableLabel.text = viewModel.fee
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        cardPaymentRootView.layer.cornerRadius = 16
        cardPaymentRootView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            cardPaymentRootView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        pinView.delegate = self
        cardNumberTextfield.delegate = self
        
        presenter = CardPaymentPresenter(view: self,
                                         apiService: ApiService.shared)
    }
    
    private func setupNextButton() {
        let nextButton = UIBarButtonItem(title: StringLiterals.Continue, style: .plain, target: self, action: #selector(userPressedContinue))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc private func userPressedContinue(shouldShowErrorMessage: Bool = true) {
        
        let cardNumber = cardNumberTextfield.text.cleanNumericString()
        let cvv = cvvTextfield.text
        let expiryDate = expiryDataTextfield.text
        let pin = pinView.text
        
        presenter.payWithCard(cardNumber: cardNumber,
                              expiryDate: expiryDate,
                              cvv: cvv,
                              pin: pin,
                              shouldShowErrorMessage: shouldShowErrorMessage,
                              fee: viewModel.fee ?? "₦0.00",
                              totalPayable: viewModel.totalPayable)
    }
    
    @IBAction func changeMethodButtonClicked(_ sender: UIButton) {
        navigateToChangePaymentMethod(viewModel: viewModel, currentPaymentMethod: .card)
    }
    
    @IBAction func refresh(_ sender: Any) {
        print("Tapped")
        openTooltip()
    }
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
    private func addTapGestureForCvvTooltip() {
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(showToolTip))
        //        cvvTextfield.rightButtonView.isUserInteractionEnabled = true
        //        cvvTextfield.rightButtonView.addGestureRecognizer(gesture)
        //
        
        cvvTextfield.rightButtonView.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
    }
    
    
    
    @objc private func openTooltip() {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 154, height: 91))
        stackView.axis = .vertical
        stackView.alignment = .fill // .Leading .FirstBaseline .Center .Trailing .LastBaseline
        stackView.distribution = .fill // .FillEqually .FillProportionally .EqualSpacing .EqualCentering
        
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "Inter-Regular", size: 9)!]
        let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "Inter-Bold", size: 9)!]
        let thirdAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font:UIFont(name: "Inter-Regular", size: 9)!]
                    

                    let firstString = NSMutableAttributedString(string: "Your CVV is the ", attributes: firstAttributes)
                    let secondString = NSAttributedString(string: "3 digit number", attributes: secondAttributes)
                    let thirdString = NSAttributedString(string: " on the back of your card ", attributes: thirdAttributes)

                    firstString.append(secondString)
                    firstString.append(thirdString)
        
        let label = UILabel(frame: .zero)
         
        label.attributedText = firstString
        label.textColor = .white
        stackView.addArrangedSubview(label)
        
        
//        NSLayoutConstraint.activate([
//
//            label.centerXAnchor
//                .constraint(equalTo: stackView.centerXAnchor),
//            label.centerYAnchor
//                .constraint(equalTo: stackView.centerYAnchor),
//            label.widthAnchor
//                .constraint(equalToConstant: 120),
//            label.heightAnchor
//                .constraint(lessThanOrEqualToConstant: 50)
//        ])
        
        EasyTipView.show(forView: self.cvvTextfield.rightButtonView,
                         withinSuperview: self.navigationController?.view,
                         attributedText: firstString
                         
                         //preferences: preferences,
        )
    }
}

extension CardPaymentViewController : MonnifyPinViewDelegate {
    
    func pinView(_ inputView: MonnifyPinView, didEnteredPin pin: String) {
        userPressedContinue(shouldShowErrorMessage: false)
    }
}

extension CardPaymentViewController: MonnifyCardTextfieldDelegate {
    
    func cardTextfield(_ cardTextfield: MonnifyCardTextfield, didChange cardNumber: String, _ validationState: CardValidationState) {
        Logger.log("didChange \(cardNumber): String, _ \(validationState): CardValidationState")
        
        if validationState == .valid {
            // Get Card Requirements
            let transactionReference = Monnify.shared.transactionResult.transactionReference
            
            let request = CardRequirementRequest(pan: cardNumber, transactionReference: transactionReference)
            
            presenter.getCardRequirements(request: request)
        } else {
            
            if !pinViewContainer.isHidden {
                pinViewContainer.fadeOut()
            }
        }
    }
}
