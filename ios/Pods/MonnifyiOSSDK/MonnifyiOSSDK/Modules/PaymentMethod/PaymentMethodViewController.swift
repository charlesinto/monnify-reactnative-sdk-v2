//
//  ViewController.swift
//  Monnify
//
//  Created by Kanyinsola on 25/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

class PaymentMethodViewController: BaseViewController {
    
    // Injected property    
    var viewModel: PaymentMethodListViewModel!
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantImageLabel: MerchantLogoView!
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var amountPayableLabel: UILabel!
    @IBOutlet weak var feePayableLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var paymentMethodTableView: UITableView!
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var presenter: PaymentMethodPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        self.navigationController?.delegate = self
        
        scrollContentView.layer.cornerRadius = 16
        scrollContentView.clipsToBounds = true
        scrollContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        presenter = PaymentMethodPresenter(view: self,
                                           apiService: ApiService.shared,
                                           preferenceManager: PreferenceManagerImplementation.shared)
        
        merchantNameLabel.text = viewModel.merchantName
        customerEmailLabel.text = viewModel.customerEmail
        amountPayableLabel.text = viewModel.totalPayable
        transactionAmountLabel.text = viewModel.totalPayable
        
        merchantImageLabel.loadImage(url: viewModel.merchantLogoUrl, name: viewModel.merchantName)
        //feePayableLabel.text = "₦10.00"
        
    }
    
    private func setupTableView() {
        paymentMethodTableView.delegate = self
        paymentMethodTableView.dataSource = self
        paymentMethodTableView.tableFooterView = UIView()
        
        if viewModel.paymentMethods.count == 1 {
            if let paymentMethod = viewModel.paymentMethods.first {
                openPaymentMethod(paymentMethod)
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
}

extension PaymentMethodViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController is InitializeTransactionViewController {
            Logger.log("WAS CALLED in PaymentMethodViewController")
            completeTransaction()
        }
    }
    
}
