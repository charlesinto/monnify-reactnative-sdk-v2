//
//  AccountTransferViewController.swift
//  Monnify
//
//  Created by Kanyinsola on 14/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

class AccountTransferViewController: BaseViewController {
    
    var viewModel: AccountTransferViewModel!
    
    @IBOutlet weak var dialCodeView: UIView!
    @IBOutlet weak var accountInformationRootView: UIView!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak  var customerEmailLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var accountTransferRootView: UIView!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var expiresInTimerTextLabel: UILabel!
    @IBOutlet weak var ussdCodeLabel: UILabel!
    @IBOutlet weak var selectBankDropDownTextfield: UITextField!
    @IBOutlet weak var payWithUssdButton: UIButton!
    @IBOutlet weak var dialCodeHintLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var accountTransferDetailsView: UIView!
    @IBOutlet weak var moneyTransferredButton: UIButton!
    @IBOutlet weak var copyIconButton: UIButton!
    @IBOutlet weak var copiedLabel: UILabel!
    
    fileprivate let banksPickerView = ToolbarPickerView()
    
    fileprivate var presenter: AccountTransferPresenterProtocol!
    
    private var selectedBank: Bank?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBanksPickerView()
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.startTimer(countDownTimeInSeconds: viewModel.accountDurationSeconds)
        presenter.startListening()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.stopListening()
    }
    
    private func setupView() {
        addTapGestureForCopyToPasteboard()

        presenter = AccountTransferPresenter(view: self,
                                             apiService: ApiService.shared)
        
        title = StringLiterals.AccountTransfer
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        amountPayableLabel.text = viewModel.totalPayable
        //amountLabel.font = UIFont
        amountLabel.text = viewModel.itemValue
        bankLabel.text = viewModel.bankName.uppercased()
        accountNameLabel.text = viewModel.accountName
        accountNumberLabel.text = viewModel.accountNumber
        feePayableLabel.text = viewModel.fee
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        accountTransferDetailsView.layer.cornerRadius = 16
        accountTransferDetailsView.clipsToBounds = true
        accountTransferDetailsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //moneyTransferredButton.applyGradient(colours: [UIColor.init(hex: "F0AA22"), UIColor.init(hex: "F05822")], locations: [0.0, 1.0])
    }
    
    private func addTapGestureForCopyToPasteboard() {
        for view in [ussdCodeLabel, dialCodeHintLabel] {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(copyUSSDCodeToPasteBoard))
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(gesture)
        }
    }
    
    @IBAction func changeMethodButtonClicked(_ sender: UIButton) {
        navigateToChangePaymentMethod(viewModel: viewModel, currentPaymentMethod: .accountTransfer)
    }
    @IBAction func copyButtonClicked(_ sender: UIButton) {
        presenter.startCopyPressedTimer()
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.accountNumberLabel.text
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
    private func setupBanksPickerView() {
        
        selectBankDropDownTextfield.addDropDownIndicator()
        selectBankDropDownTextfield.tintColor = UIColor.clear
        
        banksPickerView.dataSource = self
        banksPickerView.delegate = self
        banksPickerView.toolbarDelegate = self
        selectBankDropDownTextfield.inputView = banksPickerView
        selectBankDropDownTextfield.inputAccessoryView = banksPickerView.toolbar
        
        selectBankDropDownTextfield.delegate = self
    }
    
    @objc private func copyUSSDCodeToPasteBoard() {
        let toastDuration = 1.0
        let alert = UIAlertController(title: nil, message: "Copied", preferredStyle: .actionSheet)
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + toastDuration) { [weak self] in
            guard let self = self else { return }

            let pasteboard = UIPasteboard.general
            pasteboard.string = self.ussdCodeLabel.text
            
            alert.dismiss(animated: true)
        }
    }
    
    @IBAction func userPressedDialCode(_ sender: Any) {
        openDialer(withPhone: ussdCodeLabel.text ?? "")
    }
    
    @IBAction func userPressedPayWithUSSD(_ sender: Any) {
        self.payWithUssdButton.isHidden = true
        self.selectBankDropDownTextfield.isHidden = false
    }
    
    private func openDialer(withPhone phone: String) {
        
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
}

extension AccountTransferViewController : AccountTransferViewDelegate {
    
    func showLoading(text: String) {
        ViewUtils.hide(accountInformationRootView, accountTransferDetailsView)
        
        showLoading(withText: text,
                    activityIndicator: activityIndicator,
                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func dismissLoading() {
        
        ViewUtils.show(accountInformationRootView, accountTransferDetailsView)
        
        dismissLoading(activityIndicator, loadingMessageLabel)
    }
    
    func updateCountDownIndicator(withText text: String, _ progress: Float) {
        
//        Logger.log("withText \(text) progress \(progress)")
        
        expiresInTimerTextLabel.text = text
        progressView.progress = progress
    }
    
    func updateCopyIcon(showCopied: Bool) {
        
        copiedLabel.isHidden = !showCopied
        copyIconButton.isHidden = showCopied
        
    }
    
    func showTransactionStatus(viewModel: TransactionStatusViewModel) {
        
        let vc = viewController(type: TransactionStatusViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AccountTransferViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
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

extension AccountTransferViewController: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.banksPickerView.selectedRow(inComponent: 0)
        self.banksPickerView.selectRow(row, inComponent: 0, animated: false)
        self.selectBankDropDownTextfield.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.selectBankDropDownTextfield.text = nil
        self.selectBankDropDownTextfield.resignFirstResponder()
    }
    
    fileprivate func refreshViewForSelection() {
        guard let bank = selectedBank, let ussdTemplate = bank.ussdTemplate else {
            return
        }
        
        let totalPayable = viewModel.totalPayableAmount?.string ?? ""
        
        let ussdCode = ussdTemplate.replacingOccurrences(of: "Amount", with: totalPayable)
            .replacingOccurrences(of: "AccountNumber", with: viewModel.accountNumber)
        
        ussdCodeLabel.text = ussdCode
        self.selectBankDropDownTextfield.text = bank.name?.capitalized
        ussdCodeLabel.layer.masksToBounds = true
        ussdCodeLabel.layer.cornerRadius =  ussdCodeLabel.bounds.size.height / 2
        
        if dialCodeView.isHidden {
            
            dialCodeView.isHidden = false
           // dialCodeButton.isHidden = false
        }
    }
}
