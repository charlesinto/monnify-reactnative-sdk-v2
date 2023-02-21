//
//  InitializeTransactionViewController.swift
//  Monnify
//
//  Created by Kanyinsola on 25/10/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import UIKit

class InitializeTransactionViewController: BaseViewController {
    
    @IBOutlet weak var activityIndicator: CardProgressView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    
    private var presenter: InitializeTransactionPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = StringLiterals.Welcome
        addCancelButton()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if presenter == nil {
            presenter = InitializeTransactionPresenter(view: self,
                                                    apiService: ApiService.shared)
            presenter?.initializeTransaction()
         }
    }
    
    private func addCancelButton() {
        
        let cancelButton = UIBarButtonItem(title: "Close",
                                           style: .plain,
                                           target: self,
                                           action: #selector(userPressedCancel))
        
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func userPressedCancel() {
        completeTransaction()
    }
}

extension InitializeTransactionViewController : InitializeTransactionViewDelegate {
    
    func showLoading(text: String) {
    
        showLoading(withText: text,
                    activityIndicator: activityIndicator,
                    loadingMessageLabel: loadingMessageLabel)
    }
    
    func dismissLoading() {
       
        dismissLoading(activityIndicator,
                       loadingMessageLabel)
    }
    
    func showPaymentMethods(viewModel: PaymentMethodListViewModel) {
        Logger.log("showPaymentMethods was called with VM \(viewModel)")
        
        let vc = self.viewController(type: PaymentMethodViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEmptyView() {
        
        loadingMessageLabel.isHidden = false
        loadingMessageLabel.text = "No payment method enabled for this transaction, please contact merchant."
    }
}

