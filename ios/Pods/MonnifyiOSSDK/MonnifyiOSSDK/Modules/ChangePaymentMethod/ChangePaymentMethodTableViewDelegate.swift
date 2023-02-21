//
//  ChangePaymentMethodTableViewDelegate.swift
//  MonnifyiOSSDK
//
//  Created by Nnaemeka Abah on 19/04/2022.
//  Copyright © 2022 Monnify. All rights reserved.
//



import UIKit

extension ChangePaymentMethodViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let paymentMethod = viewModel.paymentMethods[indexPath.row]
        
        openPaymentMethod(paymentMethod)
    }
    
    func openPaymentMethod(_ paymentMethod: PaymentMethod) {
        if paymentMethod == .card {
            presenter.initializeCardPayment()
        } else if paymentMethod == .accountTransfer {
            presenter.initializeAccountTransfer()
        } else if paymentMethod == .ussd {
            presenter.initializeUssdPayment()
        } else if paymentMethod == .phone {
            presenter.initializePhoneTransfer()
        } else if paymentMethod == .bank {
            presenter.initializeBankTransfer()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //viewModel.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0.0)
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat(0.1)
//    }
//
}

extension ChangePaymentMethodViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.identifier,
                                                 for: indexPath) as! PaymentMethodTableViewCell
        
        cell.paymentMethod = PaymentMethodViewModel.fromPaymentMethod(
            paymentMethod: viewModel.paymentMethods[indexPath.row])
        
        return cell
    }
}
