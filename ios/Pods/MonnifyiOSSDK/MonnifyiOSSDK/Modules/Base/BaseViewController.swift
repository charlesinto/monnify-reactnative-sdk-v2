import UIKit
import Foundation
import SafariServices
import IQKeyboardManagerSwift

class BaseViewController: UIViewController {
    
    private var rectValue: CGRect?
    private var frame: CGRect?
    
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        
        // overrideUserInterfaceStyle is available with iOS 13
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }
}

extension BaseViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        Logger.log("Keyboard Will show")
        guard let userInfo = notification.userInfo else {return}
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        rectValue = keyboardSize.cgRectValue
        var shouldMoveViewUp = false
        
        let focused = self.view.currentFirstResponder() as? UIView
        if let activeTextField =  focused as? UITextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - rectValue!.height
            
            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y -= rectValue!.height
            self.frame = self.view.frame
        }
        Logger.log("Keyboard Did show")
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        if frame != nil {
            self.view.frame = self.frame!
            self.view.frame.origin.y += rectValue!.height
            Logger.log("reset frame")
        }
        
        Logger.log("Keyboard has hidden")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: Common Functionalities Used in various View Controllers

extension BaseViewController {
    
    func navigateToPaymentMethodList(){
        if let vc = navigationController?.viewControllers.filter({$0 is PaymentMethodViewController}).first {
            navigationController?.popToViewController(vc, animated: false)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func navigateToChangePaymentMethod(viewModel: TransactionDetails, currentPaymentMethod: PaymentMethod) {
        let paymentMethods = Monnify.shared.metadata.paymentMethods.filter {$0 != currentPaymentMethod}
        
        let viewModel = ChangePaymentMethodViewModel(
            paymentMethods: paymentMethods,
            currentPaymentMethod: currentPaymentMethod,
            totalPayable: viewModel.totalPayable,
            merchantName: viewModel.merchantName,
            customerEmail: viewModel.customerEmail,
            merchantLogoUrl: viewModel.merchantLogoUrl)
        
        let vc = viewController(type: ChangePaymentMethodViewController.self)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setBackButtonTitleToBack() {
        navigationItem.title = nil
        navigationItem.title = StringLiterals.Back
    }
    
    func push<T: UIViewController>(viewController: T.Type,
                                   from storyBoardName: String = StoryBoardIdentifiers.Main) {
        let vc = self.viewController(type: viewController,
                                     from: storyBoardName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private func getSubviewsOf<T: UIView>(view: UIView) -> [T] {
        var subviews = [T]()
        
        for subview in view.subviews {
            subviews += getSubviewsOf(view: subview) as [T]
            
            if let subview = subview as? T {
                subviews.append(subview)
            }
        }
        
        return subviews
    }
    
    func popToOrPushViewController(vc: UIViewController) {
        if let viewCs = self.navigationController?.viewControllers
        {
            if viewCs.contains(vc) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
            else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func popBackStack(numberOfViewControllersToPop count: Int = 2) {
        if let viewControllers = self.navigationController?.viewControllers as [UIViewController]? {
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - count - 1], animated: true)
        }
    }
    
}
