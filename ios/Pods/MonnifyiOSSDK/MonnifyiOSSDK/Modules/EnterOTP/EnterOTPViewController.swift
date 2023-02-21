//
//  EnterOTPViewController.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

class EnterOTPViewController: BaseViewController {
    
    var viewModel: EnterOTPViewModel!
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    @IBOutlet weak var itemValueLabel: UILabel!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var otpMessageLabel: UILabel!
    @IBOutlet weak var otpMessageRootView: UIView!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var otpTextfield: MonnifyTextfield!
    
    private var presenter: EnterOTPPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        presenter = EnterOTPPresenter(view: self,
                                      apiService: ApiService.shared)
        
        title = StringLiterals.EnterOTP
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        amountPayableLabel.text = viewModel.totalPayable
        itemValueLabel.text = viewModel.itemValue
        feePayableLabel.text = viewModel.fee
        otpMessageLabel.text = viewModel.tokenData?.message
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
        setupNextButton()
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        otpMessageRootView.layer.cornerRadius = 16
        otpMessageRootView.clipsToBounds = true
        otpMessageRootView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupNextButton() {
        let nextButton = UIBarButtonItem(title: StringLiterals.Continue,
                                         style: .plain,
                                         target: self,
                                         action: #selector(userPressedContinue))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @IBAction func confirmButtonPressed(_ sender: GradientButton) {
        userPressedContinue()
    }
    
    @objc private func userPressedContinue() {
        switch viewModel.paymentMethod {
        case .card:
            presenter.authorizeCardTransaction(withOTP: otpTextfield.text,
                                               viewModel!.tokenData?.id ?? "")
        case .bank:
            presenter.authorizeBankTransaction(withOTP: otpTextfield.text)
        default:
            return
        }
        
    }
    
    @IBAction func changeMethodButtonClicked(_ sender: UIButton) {
        navigateToChangePaymentMethod(viewModel: viewModel, currentPaymentMethod: viewModel.paymentMethod)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
}


extension EnterOTPViewController : EnterOTPViewDelegate {
    func getViewModel() -> EnterOTPViewModel {
        viewModel
    }
    
    
    func showLoading(text: String) {
        
        ViewUtils.hide(otpTextfield, otpMessageRootView)
        showLoading(withText: text,
                    activityIndicator: activityIndicator,
                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func dismissLoading() {
        ViewUtils.show(otpTextfield, otpMessageRootView)
        
        dismissLoading(activityIndicator,
                       loadingMessageLabel)
    }
    
    func open3DSAuthWebView(secure3dData: Secure3dData) {
        let vc = viewController(type: Secure3DAuthenticationViewController.self)
        vc.secure3DSData = secure3dData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTransactionStatus(viewModel: TransactionStatusViewModel) {
        let vc = viewController(type: TransactionStatusViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
