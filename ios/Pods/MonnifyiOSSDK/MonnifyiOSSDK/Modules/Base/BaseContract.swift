import Foundation

protocol BaseView: NSObjectProtocol {
    
    func disableUserInteraction()
        
    func enableUserInteraction()

    func showAlertDialog(message text: String)

    func showAlertDialog(title: String, message text: String)
    
    func completeTransaction()
}

protocol BasePresenter {}
