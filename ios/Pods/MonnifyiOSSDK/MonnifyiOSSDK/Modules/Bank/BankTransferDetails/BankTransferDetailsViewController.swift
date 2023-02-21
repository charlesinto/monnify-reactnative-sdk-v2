//
//  BankTransferDetailsViewController.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 23/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit

class BankTransferDetailsViewController: BaseViewController {

    var viewModel: BankTransferDetailsViewModel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var totalPayableLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    @IBOutlet weak var selectBankDropdownTextField: UITextField!
    @IBOutlet weak var bankNameLabel: UITextField!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var bankTransferDetailsView: UIView!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var accountNumberTextField: MonnifyTextfield!
    @IBOutlet weak var accountNameView: UIView!
    @IBOutlet weak var verifyAccountButton: GradientButton!
    @IBOutlet weak var accountNameLabel: UILabel!
    
    fileprivate var presenter: BankTransferDetailsPresenter!
    
    private var accountVerified : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
   
    
    private func setupView() {

        presenter = BankTransferDetailsPresenter(view: self,
                                             apiService: ApiService.shared)
        
        title = StringLiterals.AccountTransfer
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        amountPayableLabel.text = viewModel.itemValue
        totalPayableLabel.text = viewModel.totalPayable
        feePayableLabel.text = viewModel.fee
        bankNameLabel.text = viewModel.bankName
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
        accountNumberTextField.textChangedDelegate = self
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        bankTransferDetailsView.layer.cornerRadius = 16
        bankTransferDetailsView.clipsToBounds = true
        bankTransferDetailsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
 
    @IBAction func changeMethodButtonClicked(_ sender: UIButton) {
        navigateToChangePaymentMethod(viewModel: viewModel, currentPaymentMethod: .bank)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    @IBAction func goBackButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyAccountButtonClicked(_ sender: GradientButton) {
        if accountNumberTextField.text.count == 10 && !accountVerified {
            presenter.getAccountDetails(bankCode: viewModel.bankCode, accountNumber: accountNumberTextField.text)
        } else {
            presenter.showOTPScreen(bankCode: viewModel.bankCode, accountNumber: accountNumberTextField.text)
        }
        
    }

}

extension BankTransferDetailsViewController: MonnifyTextFieldDelegate {
    
    func textField(_ textField: MonnifyTextfield,
                   didChange text: String) {
        
        Logger.log("Entered account number \(viewModel.bankCode) - \(text)")
        
        accountVerified = false
        
        if text.count == 10 {
            verifyAccountButton.isEnabled = true

        } else {
            verifyAccountButton.isEnabled = false
            verifyAccountButton?.setTitle(StringLiterals.VerifyAccount, for: .normal)
            self.hideAccountDetails()
        }
    
    }
    
    func textFieldDidEndEditing(_ text: String) {
        presenter.getAccountDetails(bankCode: viewModel.bankCode, accountNumber: text)

    }
}

extension BankTransferDetailsViewController : BankTransferDetailsViewDelegate {
    func updateAccountDetails(accountName: String) {
        if accountNameView.isHidden {
            accountNameView.isHidden = false
            accountNameLabel.text = accountName
            // FIXME: Implement proper logic to determine if account fetch failed
            accountVerified = true
            verifyAccountButton?.setTitle(StringLiterals.Proceed, for: .normal)
            verifyAccountButton.isEnabled = true

        }
        
    }
    
    func getViewModel() -> BankTransferDetailsViewModel {
        viewModel
    }
    
    func showOTPScreen(viewModel: EnterOTPViewModel) {
        let vc = viewController(type: EnterOTPViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func hideAccountDetails() {
        accountNameView.isHidden = true
    }
    
    
    func showLoading(text: String) {
        ViewUtils.hide(bankTransferDetailsView)
        
        showLoading(withText: text,
                    activityIndicator: activityIndicator,
                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func dismissLoading() {
        
        ViewUtils.show(bankTransferDetailsView)
        
        dismissLoading(activityIndicator, loadingMessageLabel)
    }
    
    func showBankTransferDetails(viewModel: BankTransferDetailsViewModel) {
        
        let vc = viewController(type: BankTransferDetailsViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func showTransactionStatus(viewModel: TransactionStatusViewModel) {
        
        let vc = viewController(type: TransactionStatusViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
