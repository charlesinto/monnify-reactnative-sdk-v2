//
//  CardValidator.swift
//  Monnify
//
//  Created by Kanyinsola on 07/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

class CardValidator {
    
    private init() {}
    
    static let shared = CardValidator()
    
    var currentYear : Int {
        let calender = Calendar.init(identifier: .gregorian)
        let year = calender.component(.year, from: Date())
        return year % 100
    }
    
    var currentMonth : Int {
        let calender = Calendar.init(identifier: .gregorian)
        let month = calender.component(.month, from: Date())
        return month
    }
    
    func validationState(forExpiryDate expiryDate: String) -> CardValidationState {
        
        let segments = expiryDate.split(separator: "/")
        
        var expirationMonthValidationState = CardValidationState.incomplete
        if segments.count > 0 {
            expirationMonthValidationState = validationState(forCardExpiryMonth: String(segments[0]))
        }
        
        var expirationYearValidationState = CardValidationState.incomplete
        
        if segments.count > 1 {
            expirationYearValidationState = validationState(forCardExpirationYear: String(segments[1]),
                                                            andExpiryMonth: String(segments[0]))
        }
        
        switch (expirationMonthValidationState, expirationYearValidationState ) {
        case (_, .invalid ), (.invalid, _):
            return .invalid
        case (_, .incomplete ), (.incomplete, _):
            return .incomplete
        case (_, .valid ), (.valid, _):
            return .valid
        }
    }
    
    private func validationState(forCardExpiryMonth expirationMonth: String) -> CardValidationState {
        
        let cleanString = expirationMonth.cleanNumericString()
        
        Logger.log("cleanString \(cleanString)")
        
        if !cleanString.containsOnlyDigits() {
            return .invalid
        }
        
        switch cleanString.count {
        case 0:
            return .incomplete
        case 1:
            return (cleanString == "0" || cleanString == "1") ? .incomplete : .valid
        case 2:
            return ( 0 < cleanString.intValue && cleanString.intValue <= 12) ? .valid : .invalid
        default:
            return .invalid
        }
    }
    
    private func validationState(forCardExpirationYear expirationYear: String,
                                 andExpiryMonth expirationMonth: String,
                                 inCurrentMonth currentMonth: Int,
                                 inCurrentYear currentYear: Int) -> CardValidationState {
        
        let currentYear = currentYear % 100
        
        if !expirationMonth.containsOnlyDigits() || !expirationYear.containsOnlyDigits() {
            return .invalid
        }
        
        let cleanMonth = expirationMonth.cleanNumericString()
        let cleanYear = expirationYear.cleanNumericString()
        
        Logger.log("currentYear \(currentYear) currentMonth \(currentMonth) cleanMonth\(cleanMonth) cleanYear \(cleanYear)")
        
        switch cleanYear.count {
        case 0, 1:
            return .incomplete
        case 2:
            if cleanYear.intValue == currentYear {
                return cleanMonth.intValue >= currentMonth ? .valid : .invalid
            } else {
                return cleanYear.intValue > currentYear ? .valid : .invalid
            }
            
        default:
            return .invalid
        }
    }
    
    private func validationState(forCardExpirationYear expirationYear: String,
                         andExpiryMonth expirationMonth: String) -> CardValidationState {
        
        return validationState(forCardExpirationYear: expirationYear,
                               andExpiryMonth: expirationMonth,
                               inCurrentMonth: currentMonth,
                               inCurrentYear: currentYear)
    }
    
    func validationState(forCvv cvv: String) -> CardValidationState {
        
        if cvv.count < 3 {
            return .incomplete
        } else {
            return .valid
        }
    }
    
    func getCardExpiryDate(fromExpiryDate expiryDate: String) -> (Int, Int) {
        
        let segments = expiryDate.split(separator: "/")
        
        if segments.count != 2 {
            return (-1, -1) // Error Code.
        }
        
        
        let expiryMonth = segments[0].intValue
        let expiryYear = segments[1].intValue + 2000
        
        return (expiryMonth, expiryYear)
    }
    
    func validationState(forCardWithNumber cardNumber: String) -> CardValidationState {
        
        let cleanCardNumber = cardNumber.cleanNumericString()
        
        if !cleanCardNumber.containsOnlyDigits() {
            return .invalid
        }
        
        let brands = possibleBrands(forCardWithNumber: cleanCardNumber)
        
        if brands.count == 0 {
            return .invalid
        } else if brands.count >= 2 {
            return .incomplete
        } else {
            let brand = brands.first!
            let expectedLength = lengthForCardBrand(brand: brand)
            
            if cleanCardNumber.count > expectedLength {
                return .invalid
            } else if brand == .verve &&
                cleanCardNumber.count >= 16 && cleanCardNumber.count <= 19 {
                return .valid
            } else if cleanCardNumber.count == expectedLength {
                return isCardNumberAValidLuhn(cleanCardNumber) ? .valid : .invalid
            } else {
                return .incomplete
            }
        }
    }
    
    private func isCardNumberAValidLuhn(_ cardNumber: String) -> Bool {
        guard !cardNumber.isEmpty else { return false }
        let revesedString = String(cardNumber.reversed())
        var oddNumberSum = 0
        var evenNumberSum = 0
        
        for index in 0..<revesedString.count {
            let digit = Int(String(revesedString[revesedString.index(revesedString.startIndex, offsetBy: index)]))!
            let pos = index + 1
            if pos % 2 == 0  {
                var aDigit = digit * 2
                let remainder = aDigit%10
                let quotient = aDigit/10
                aDigit = remainder + quotient
                oddNumberSum += aDigit
            }
            else {
                evenNumberSum += digit
            }
        }
        let total = evenNumberSum + oddNumberSum
        return total % 10 == 0
    }
    
    func possibleBrands(forCardWithNumber cardNumber: String) ->  [CardBrand] {
        var possibleBrands = [CardBrand]()
        
        for brand in CardBrand.allValues {
            if doPrefixMatch(forCardBrand: brand, andCardPrefix: cardNumber) {
                possibleBrands.append(brand)
            }
        }
        return possibleBrands
    }
    
    private func doPrefixMatch(forCardBrand cardBrand: CardBrand,
                               andCardPrefix cardPrefix: String) -> Bool {
        
        if cardPrefix.count == 0 {
            return true
        }
        
        let allValidPrefixes = validPrefixes(forCardBrand: cardBrand)
        
        for prefix in allValidPrefixes {
            if prefix.count >= cardPrefix.count && prefix.hasPrefix(cardPrefix) ||
                cardPrefix.count >= prefix.count && cardPrefix.hasPrefix(prefix) {
                return true
            }
            
        }
        
        return false
    }
    
    private func validPrefixes(forCardBrand brand: CardBrand) -> [String] {
        
        switch brand {
        case .verve:
            return ["5060", "5061", "5078", "5079", "6500"]
        case .mastercard:
            return ["501", "502", "503", "504", "505", "5062", "5063", "5064",
                    "5065", "5066", "5067", "5068", "5069","5070", "5071",
                    "5072", "5073", "5074", "5075", "5076", "5077","508","509",
                    "500", "51", "52", "53", "54", "55", "56", "57", "58",
                    "59"]
        case .visa:
            return ["40", "41", "42", "43", "44", "45", "46", "47", "48", "49"]
        default:
            return []
        }
    }
    
    func lengthForCardBrand(brand: CardBrand) -> Int {
        if brand == .verve {
            return 19
        }
        return 16
    }
}

enum CardValidationState {
    case valid
    case incomplete
    case invalid
}
