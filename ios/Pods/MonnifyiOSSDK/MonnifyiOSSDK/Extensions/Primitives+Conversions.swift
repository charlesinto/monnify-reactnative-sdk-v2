import Foundation

extension String.SubSequence {
    
    var intValue: Int {
        return String(self).intValue
    }
}

extension Int {
    var decimalValue: Decimal {
        return Decimal.init(self)
    }
}

extension Double {
    
    var decimalValue: Decimal {
        return Decimal.init(self)
    }
    
    var intValue : Int {
        return Int(self)
    }
    
    var string: String {
        return String(self)
    }
    
    func commaSeparatedNairaValue(currencyCode: String = "₦") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.currencySymbol = currencyCode
        return "\(numberFormatter.string(from: NSNumber(value: self)) ?? "")"
    }
}

extension Float {
    var intValue: Int {
        return Int(self)
    }
}

extension Decimal {
    
    func commaSeparatedNairaValue(currencyCode: String = "₦") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.currencySymbol = currencyCode
        return numberFormatter.string(from: self as NSDecimalNumber) ?? ""
    }
    
    var string: String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.string(from: self as NSDecimalNumber) ?? ""
    }
}

extension Bool {
    
    var string: String {
        return String(self)
    }
}
