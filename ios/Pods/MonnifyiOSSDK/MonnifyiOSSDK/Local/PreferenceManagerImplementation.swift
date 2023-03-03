//
//  PreferenceManagerImplementation.swift
//  Restaurants
//
//  Created by Kanyinsola on 02/11/2019.
//  Copyright © 2019 DeliveryHero. All rights reserved.
//

import Foundation

class PreferenceManagerImplementation: PreferenceManager {
    var userDefaults: UserDefaults
    
    private init(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    static let shared = PreferenceManagerImplementation(UserDefaults.standard)
    
}
