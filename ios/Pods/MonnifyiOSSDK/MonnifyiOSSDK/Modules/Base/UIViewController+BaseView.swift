
import UIKit

// MARK: - Generic View Setup
extension UIViewController: BaseView {
    
    func disableUserInteraction() {
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
    }
    
    func enableUserInteraction() {
        self.view.isUserInteractionEnabled = true
    }
    
    func showAlertDialog(message text: String) {
        createAlertDialog(message: text)
    }
    
    func showAlertDialog(title: String, message text: String) {
        createAlertDialog(title: title, message: text)
    }
    
    func completeTransaction() {
        Monnify.shared.completeTransaction()
    }
}

// Mark - Common View Actions

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    func viewController<T: UIViewController>(type: T.Type,
                                             from storyBoardName: String = StoryBoardIdentifiers.Main) -> T {
        let storyboard = UIStoryboard (name: storyBoardName, bundle: Bundle(for: Monnify.self) )
        let storyBoardID = (type as UIViewController.Type).storyboardID
        
        return storyboard.instantiateViewController(withIdentifier: storyBoardID) as! T
    }
    
    func setNormalTitle(_ title: String){
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = false
        self.title = title;
    }
    
    func createAlertDialog(title: String = "Oops!",
                           message: String = StringLiterals.GenericNetworkError,
                           ltrActions: [UIAlertAction]! = []) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        
        if(ltrActions.count == 0){
            let defaultAction = UIAlertAction(title: StringLiterals.Ok,
                                              style: .default,
                                              handler: nil)
            alertController.addAction(defaultAction )
        }else{
            for x in ltrActions {
                alertController.addAction(x as UIAlertAction);
            }
        }
        
        self.present(alertController, animated: true, completion: nil);
    }
    
    func createActionSheet(title: String? = nil, message: String? = nil,
                           ltrActions: [UIAlertAction]! = [] ,
                           preferredActionPosition: Int = 0, sender: UIView? = nil ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet);
        
        if(ltrActions.count == 0){
            let defaultAction = UIAlertAction(title: StringLiterals.Ok, style: .default, handler: nil)
            alertController.addAction(defaultAction);
        } else {
            for (index , x) in ltrActions.enumerated() {
                alertController.addAction(x as UIAlertAction);
                if index == preferredActionPosition {
                    alertController.preferredAction = x as UIAlertAction
                }
            }
        }
        
        if let popoverController = alertController.popoverPresentationController, let sender = sender {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        self.present(alertController, animated: true, completion: nil);
    }
    
    func creatAlertAction(_ title: String = StringLiterals.Ok,
                          style: UIAlertAction.Style = .default,
                          clicked: ((_ action: UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: clicked)
    }
}

extension UIViewController {
    
    func showLoading(withText text: String,
                     activityIndicator: CardProgressView,
                     loadingMessageLabel: UILabel) {
        
        disableUserInteraction()
        activityIndicator.isAnimating = true
        activityIndicator.isHidden = false
        loadingMessageLabel.text = text
        loadingMessageLabel.isHidden = false
    }
    
    func dismissLoading(_ activityIndicator: CardProgressView,
                        _ loadingMessageLabel: UILabel) {
        
        enableUserInteraction()
        activityIndicator.isHidden = true
        activityIndicator.isAnimating = false
        loadingMessageLabel.isHidden = true
    }
}
