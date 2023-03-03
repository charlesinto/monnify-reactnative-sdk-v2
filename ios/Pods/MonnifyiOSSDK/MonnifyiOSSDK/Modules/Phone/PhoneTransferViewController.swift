//
//  PayWithPhoneViewController.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 17/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit
import Lottie

class PhoneTransferViewController: BaseViewController {

    var viewModel: PhoneTransferViewModel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var totalPayableLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var phoneTransferDetailsView: UIView!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var phoneNumberTextField: MonnifyTextfield!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var continueButton: GradientButton!
    @IBOutlet weak var phoneLoadingAnimationView: LottieAnimationView!
    @IBOutlet weak var phoneTransferLoadingView: UIView!
    
    fileprivate var presenter: PhoneTransferPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.startListening()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.stopListening()
    }
    
    @IBAction func continueButtonClicked(_ sender: GradientButton) {
        if phoneNumberTextField.text.count == 11  {
            presenter.initializePhoneTransfer(phoneNumber: phoneNumberTextField.text)
        }
    }
    
    private func setupView() {

        presenter = PhoneTransferPresenter(view: self,
                                             apiService: ApiService.shared)
        
        title = StringLiterals.AccountTransfer
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        amountPayableLabel.text = viewModel.totalPayable
        totalPayableLabel.text = viewModel.totalPayable
    
        phoneNumberTextField.textChangedDelegate = self
          
        phoneLoadingAnimationView.contentMode = .scaleAspectFit
        phoneLoadingAnimationView.loopMode = .loop
        phoneLoadingAnimationView.animationSpeed = 1.0
        phoneLoadingAnimationView.play()

        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        phoneTransferDetailsView.layer.cornerRadius = 16
        phoneTransferDetailsView.clipsToBounds = true
        phoneTransferDetailsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        phoneTransferLoadingView.layer.cornerRadius = 16
        phoneTransferLoadingView.clipsToBounds = true
        phoneTransferLoadingView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
        //moneyTransferredButton.applyGradient(colours: [UIColor.init(hex: "F0AA22"), UIColor.init(hex: "F05822")], locations: [0.0, 1.0])
    }

    @IBAction func changeMethodButtonClicked(_ sender: UIButton) {
        navigateToChangePaymentMethod(viewModel: viewModel, currentPaymentMethod: .phone)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
}

extension PhoneTransferViewController : PhoneTransferViewDelegate {
    
    func showLoading(text: String) {
        phoneLoadingAnimationView.play()
        ViewUtils.hide(phoneTransferDetailsView)
        ViewUtils.show(phoneTransferLoadingView)

        //phoneGifImageView.loadGif(asset: "payattitude")

//        showLoading(withText: "",
//                    activityIndicator: phoneGifImageView,
//                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func getViewModel() -> PhoneTransferViewModel {
        viewModel
    }
    
    func dismissLoading() {
        
        ViewUtils.show(phoneTransferDetailsView)
        ViewUtils.hide(phoneTransferLoadingView)
        phoneLoadingAnimationView.stop()

        //dismissLoading(phoneGifImageView, loadingMessageLabel)
    }
    
   
    
    func showTransactionStatus(viewModel: TransactionStatusViewModel) {
        
        let vc = viewController(type: TransactionStatusViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension PhoneTransferViewController: MonnifyTextFieldDelegate {
    
    func textField(_ textField: MonnifyTextfield,
                   didChange text: String) {
        
        Logger.log("Entered phone number - \(text)")
        
        
        if text.count == 11 {
            continueButton.isEnabled = true

        } else {
            continueButton.isEnabled = false
           
        }
    
    }
    
    func textFieldDidEndEditing(_ text: String) {
        presenter.initializePhoneTransfer(phoneNumber: text)
    }
}

