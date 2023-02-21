//
//  CardBrand.swift
//  Monnify
//
//  Created by Kanyinsola on 09/11/2019.
//  Copyright © 2019 TeamApt. All rights reserved.
//

import Foundation

enum CardBrand {
    case visa
    case mastercard
    case verve
    case unknown
}

extension CardBrand {
    static var allValues: [CardBrand] {
        return [ visa, mastercard, verve ]
    }
}
