//
//  ChangePaymentMethodViewController.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 13/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//

import UIKit

class ChangePaymentMethodViewController: BaseViewController {
    
    // Injected property
    var viewModel: ChangePaymentMethodViewModel!
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLogoImageView: MerchantLogoView!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var totalPayableLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var paymentMethodTableView: UITableView!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var currentPaymentMethodImageView: UIImageView!
    @IBOutlet weak var currentPaymentMethodLabel: UILabel!
    var presenter: PaymentMethodPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()

    }
    
    private func setupView() {
        
        presenter = PaymentMethodPresenter(view: self,
                                           apiService: ApiService.shared,
                                           preferenceManager: PreferenceManagerImplementation.shared)
        
        title = StringLiterals.AccountTransfer
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        amountPayableLabel.text = viewModel.totalPayable
        totalPayableLabel.text = viewModel.totalPayable
        let currentPaymentMethodDetails = PaymentMethodViewModel.fromPaymentMethod(paymentMethod: viewModel.currentPaymentMethod)
        currentPaymentMethodImageView.image = currentPaymentMethodDetails.icon
        currentPaymentMethodLabel.text = currentPaymentMethodDetails.title
    
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        merchantLogoImageView.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        
    }
    
    private func setupTableView() {
        paymentMethodTableView.delegate = self
        paymentMethodTableView.dataSource = self
        paymentMethodTableView.tableFooterView = UIView()
        
    }

    @IBAction func hideButtonClicked(_ sender: UIButton) {
        self.popBackStack(numberOfViewControllersToPop: 1)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
}
