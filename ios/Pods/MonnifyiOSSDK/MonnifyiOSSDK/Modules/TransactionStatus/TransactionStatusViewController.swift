//
//  TransactionStatusViewController.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit
import Lottie

class TransactionStatusViewController: BaseViewController {
    
    var viewModel: TransactionStatusViewModel!
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var totalPayableLabel: UILabel!
    @IBOutlet weak var itemValueLabel: UILabel!
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var terminationCountDownLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var scrollContentView: UIView!
    
    private var presenter: TransactionStatusPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        
        presenter = TransactionStatusPresenter(view: self)
        
        title = StringLiterals.TransactionStatus
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        statusTitleLabel.text = viewModel.statusTitle
        totalPayableLabel.text = viewModel.amountPaid
        feePayableLabel.text = viewModel.fee
        itemValueLabel.text = viewModel.itemValue
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        iconImageView.image = viewModel.image
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.navigationController?.delegate = self
        
        if viewModel.shouldComplete {
            actionButton.setTitle("Return to Merchant", for: .normal)
        } else {
            terminationCountDownLabel.isHidden = true
            actionButton.setTitle("Try another payment method", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.shouldComplete {
            presenter.startTerminationCountDown()
        } else {
            // show button.
        }
    }
    
    @IBAction private func userPressedActionButton() {
        
        if viewModel.shouldComplete {
            completeTransaction()
        } else {
            gotoPaymentMethodScreen()
        }
    }
    
    private func gotoPaymentMethodScreen() {
        if let vc = navigationController?.viewControllers.filter({$0 is PaymentMethodViewController}).first {
            navigationController?.popToViewController(vc, animated: false)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
}

extension TransactionStatusViewController: TransactionStatusViewDelegate {
    
    func updateCountDownIndicator(withText text: String) {
        terminationCountDownLabel.text = text
    }
}

extension TransactionStatusViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        Logger.log("willShow \( type(of: viewController)):")
        
        if (viewController is AccountTransferViewController ||
            viewController is CardPaymentViewController ||
            viewController is EnterOTPViewController ||
            viewController is Secure3DAuthenticationViewController) {
            
            if viewModel.shouldComplete {
                completeTransaction()
            } else {
                gotoPaymentMethodScreen()
            }
        }
    }
}
