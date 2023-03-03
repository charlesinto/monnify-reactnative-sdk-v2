import UIKit

extension UITextField {
    
    func addDropDownIndicator() {
        let main = UIView()
        addSubview(main)
        
        main.translatesAutoresizingMaskIntoConstraints = false
        main.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        main.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        let dropDownIndicator = UIImageView();
        dropDownIndicator.contentMode = .scaleAspectFit
        main.addSubview(dropDownIndicator)
        dropDownIndicator.translatesAutoresizingMaskIntoConstraints = false
        dropDownIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true;
        dropDownIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true;
        dropDownIndicator.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dropDownIndicator.heightAnchor.constraint(equalToConstant: 8).isActive = true
        dropDownIndicator.image = UIImage.initWithName("drop-down-arrow")
    }
    
}
