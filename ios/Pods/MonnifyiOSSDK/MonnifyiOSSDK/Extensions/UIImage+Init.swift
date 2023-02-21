import UIKit

extension UIImage {
    
    static func initWithName(_ name: String) -> UIImage? {
        return UIImage(named: name , in: Bundle(for: Monnify.self),
                       compatibleWith: nil)
    }
    
    static func imageFromBase64(_ base64: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
                    return nil
                }
                return UIImage(data: imageData)
    }
    
    static func imageFromLabel(label: UILabel) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(label.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        label.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


