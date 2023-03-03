import UIKit

final class ViewUtils {
    
    static func hide(_ views: UIView...) {
        for view in views {
            view.isHidden = true
        }
    }
    
    static func show(_ views: UIView...) {
        for view in views {
            view.isHidden = false
        }
    }
}
