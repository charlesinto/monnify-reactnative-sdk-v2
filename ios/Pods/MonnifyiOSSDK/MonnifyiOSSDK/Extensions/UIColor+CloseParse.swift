import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: alpha
        )
    }
}


//MARK: App Colors
extension UIColor {
    
    static var appAccent: UIColor {
        return UIColor(hex: "FFCD3F", alpha: 0.15)
    }
    
    static var appAccentThin: UIColor{
        return UIColor(hex: "FFCD3F")
    }
    
    static var appError: UIColor{
        return UIColor(hex: "C41426")
    }
    
    static var appWhite: UIColor{
        return UIColor(hex: "FFFFFF")
    }
    
    static var appDisableModeColor: UIColor{
        return UIColor(hex: "E0E0E0")
    }
    
    static var appOrange: UIColor{
        return UIColor(hex: "F57F45")
    }
    
    static var appRed: UIColor{
        return UIColor(hex: "F57F45")
    }
    
    static var appGrey: UIColor{
        return UIColor(hex: "8DC63F")
    }
    
    static var appYellow: UIColor{
        return UIColor(hex: "FFCD3F")
    }
    
    static var appBlack: UIColor{
        return UIColor(hex: "1A0C2F")
    }
    
    static var appPeach2: UIColor{
        return UIColor(hex: "FE727B")
    }
    
    static var appPeach1: UIColor{
        return UIColor(hex: "FF9C9D")
    }
    
    static var appGrdPeach: UIColor{
        return UIColor(hex: "F57F45")
    }
    
    static var appGrdOrangeStart: UIColor{
        return UIColor(hex: "F0AA22")
    }
    
    static var appGrdOrangeEnd: UIColor{
        return UIColor(hex: "F05822")
    }
    
    static var appGreen1: UIColor{
        return UIColor(hex: "1D3B2D")
    }
    
    static var appGreen2: UIColor{
        return UIColor(hex: "8DC63F")
    }
    
    static var appGrdGreen: UIColor{
        return UIColor(hex: "00858D")
    }
    
    static var appBlue1: UIColor{
        return UIColor(hex: "4A76FD")
    }
    
    static var appBlue2: UIColor{
        return UIColor(hex: "4A76FD")
    }
    
    static var appGrdBlue: UIColor{
        return UIColor(hex: "4A76FD")
    }
    
    static var appPink1: UIColor{
        return UIColor(hex: "D31D79")
    }
    
    static var appPink2: UIColor{
        return UIColor(hex: "FE727B")
    }
    
    static var appGrdPink: UIColor{
        return UIColor(hex: "F57F45")
    }
    
    static var appPurple1: UIColor{
        return UIColor(hex: "553679")
    }
    
    static var appPurple2: UIColor{
        return UIColor(hex: "913398")
    }
    
    static var appGrdPurple: UIColor{
        return UIColor(hex: "553679")
    }
}
