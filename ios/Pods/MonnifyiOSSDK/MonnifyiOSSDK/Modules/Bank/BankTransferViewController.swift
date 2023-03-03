//
//  PayWithBankViewController.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 17/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit

class BankTransferViewController: BaseViewController {

    var viewModel: BankTransferViewModel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var totalPayableLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    @IBOutlet weak var selectBankDropdownTextField: UITextField!
    @IBOutlet weak var bankTransferDetailsView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    
    fileprivate let banksPickerView = ToolbarPickerView()
    fileprivate var presenter: BankTransferPresenter!

    private var selectedBank: Bank?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBanksPickerView()
        setupView()
    }
    
    
    private func setupBanksPickerView() {
        
        selectBankDropdownTextField.addDropDownIndicator()
        selectBankDropdownTextField.tintColor = UIColor.clear
        
        banksPickerView.dataSource = self
        banksPickerView.delegate = self
        banksPickerView.toolbarDelegate = self
        selectBankDropdownTextField.inputView = banksPickerView
        selectBankDropdownTextField.inputAccessoryView = banksPickerView.toolbar
        
        selectBankDropdownTextField.delegate = self
    }
    
    private func setupView() {

        presenter = BankTransferPresenter(view: self,
                                             apiService: ApiService.shared)
        
        title = StringLiterals.AccountTransfer
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        amountPayableLabel.text = viewModel.itemValue
        totalPayableLabel.text = viewModel.totalPayable
        feePayableLabel.text = viewModel.fee
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        bankTransferDetailsView.layer.cornerRadius = 16
        bankTransferDetailsView.clipsToBounds = true
        bankTransferDetailsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //moneyTransferredButton.applyGradient(colours: [UIColor.init(hex: "F0AA22"), UIColor.init(hex: "F05822")], locations: [0.0, 1.0])
    }
    
    @IBAction func changeMethodButtonClicked(_ sender: UIButton) {
        navigateToChangePaymentMethod(viewModel: viewModel, currentPaymentMethod: .bank)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
    // there is only one text field currently so no need for a tag check
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.banksPickerView.selectRow(0, inComponent: 0, animated: true)
        self.selectedBank = viewModel.banks[0]
    }

}

extension BankTransferViewController : BankTransferViewDelegate {
    func getViewModel() -> BankTransferViewModel {
        viewModel
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

extension BankTransferViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.banks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.banks[row].name?.capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedBank = viewModel.banks[row]
        refreshViewForSelection()
        
    }
}

extension BankTransferViewController: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.banksPickerView.selectedRow(inComponent: 0)
        self.banksPickerView.selectRow(row, inComponent: 0, animated: false)
        refreshViewForSelection()
        self.selectBankDropdownTextField.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.selectBankDropdownTextField.text = nil
        self.selectBankDropdownTextField.resignFirstResponder()
    }
    
    fileprivate func refreshViewForSelection() {
        guard let bank = selectedBank, let bankCode = bank.code else {
            return
        }
        
        self.selectBankDropdownTextField.text = bank.name?.capitalized
                
        self.presenter.initializeBankTransferDetails(String(bankCode), bank.name?.capitalized ?? "")
        
        //let totalPayable = viewModel.totalPayableAmount.string
        
//        let ussdCode = ussdTemplate.replacingOccurrences(of: "Amount", with: totalPayable)
//            .replacingOccurrences(of: "AccountNumber", with: viewModel.accountNumber)
//
//        ussdCodeLabel.text = ussdCode
//        self.selectBankDropdownTextField.text = bank.name?.capitalized
//        ussdCodeLabel.layer.masksToBounds = true
//        ussdCodeLabel.layer.cornerRadius =  ussdCodeLabel.bounds.size.height / 2
//
//        if dialCodeView.isHidden {
//
//            dialCodeView.isHidden = false
//           // dialCodeButton.isHidden = false
//        }
    }
}

