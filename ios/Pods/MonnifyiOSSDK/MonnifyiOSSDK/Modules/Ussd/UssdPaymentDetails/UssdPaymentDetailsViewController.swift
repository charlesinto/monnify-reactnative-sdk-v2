//
//  UssdPaymentDetailsViewController.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 21/03/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit

class UssdPaymentDetailsViewController: BaseViewController {
    
    //injected property
    var viewModel: UssdPaymentDetailsViewModel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var totalPayableLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
  
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var ussdTransferDetailsView: UIView!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var ussdCodeLabel: UILabel!
    @IBOutlet weak var copyUssdCodeLabel: UILabel!
    @IBOutlet weak var copyUSSDButton: UIButton!
    @IBOutlet weak var copiedLabel: UILabel!
    
    fileprivate var presenter: UssdPaymentDetailsPresenterProtocol!

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
    
    @IBAction func changeMethodButtonClicked(_ sender: UIButton) {
        navigateToChangePaymentMethod(viewModel: viewModel, currentPaymentMethod: .ussd)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func selectAnotherBankButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyButtonPressed(_ sender: Any) {
        presenter.startCopyPressedTimer()
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.ussdCodeLabel.text
    }
    
    
    
    private func setupView() {
        
        presenter = UssdPaymentDetailsPresenter(view: self,
                                             apiService: ApiService.shared)

        addTapGestureForCopyToPasteboard()

        title = StringLiterals.AccountTransfer
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        amountPayableLabel.text = viewModel.totalPayable
        totalPayableLabel.text = viewModel.totalPayable
        bankNameLabel.text = viewModel.bankName.uppercased()
        ussdCodeLabel.text = viewModel.ussdCode
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        ussdTransferDetailsView.layer.cornerRadius = 16
        ussdTransferDetailsView.clipsToBounds = true
        ussdTransferDetailsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //moneyTransferredButton.applyGradient(colours: [UIColor.init(hex: "F0AA22"), UIColor.init(hex: "F05822")], locations: [0.0, 1.0])
    }
    
    private func addTapGestureForCopyToPasteboard() {
        for view in [ussdCodeLabel, copyUssdCodeLabel] {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(copyUSSDCodeToPasteBoard))
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(gesture)
        }
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


}

extension UssdPaymentDetailsViewController : UssdPaymentDetailsViewDelegate {
    
    func showLoading(text: String) {
        ViewUtils.hide(ussdTransferDetailsView)
        
        showLoading(withText: text,
                    activityIndicator: activityIndicator,
                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func dismissLoading() {
        
        ViewUtils.show(ussdTransferDetailsView)
        
        dismissLoading(activityIndicator, loadingMessageLabel)
    }
    
    func showTransactionStatus(viewModel: TransactionStatusViewModel) {
        
        let vc = viewController(type: TransactionStatusViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateCopyIcon(showCopied: Bool) {
        
        copiedLabel.isHidden = !showCopied
        copyUSSDButton.isHidden = showCopied
        
    }
}

