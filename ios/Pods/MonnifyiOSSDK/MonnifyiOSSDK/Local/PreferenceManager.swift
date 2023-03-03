//
//  PreferenceManager.swift
//  Restaurants
//
//  Created by Kanyinsola on 02/11/2019.
//  Copyright © 2019 DeliveryHero. All rights reserved.
//

import Foundation

protocol PreferenceManager {
    
    var userDefaults: UserDefaults {get}
    
    func persistBanksArray(banks: [Bank])
    
    func persistProviderBanksArray(banks: [Bank])
    
    func getBanks() -> [Bank]
    
    func getProviderBanks() -> [Bank]

    func persistInt(value: Int, key: String)
    
    func readInt(key: String) -> Int
    
    func persistDouble(value: Double, key: String)
       
    func readDouble(key: String) -> Double
    
    func persistString(value: String, key: String)
       
    func readString(key: String) -> String?
    
    func delete(key: String)
    
    func delete(keys: String...)
    
    func contains(key: String) -> Bool
}

extension PreferenceManager {
        
    func persistBanksArray(banks: [Bank]) {
        delete(key: PersistenceIDs.Banks)
        let banksData = try? JSONEncoder().encode(banks)
        userDefaults.set(banksData, forKey: PersistenceIDs.Banks)
    }
    
    func persistProviderBanksArray(banks: [Bank]) {
        delete(key: PersistenceIDs.ProviderBanks)
        let banksData = try? JSONEncoder().encode(banks)
        userDefaults.set(banksData, forKey: PersistenceIDs.ProviderBanks)
    }
    
    func getBanks() -> [Bank] {
        if let banksData = UserDefaults.standard.data(forKey: PersistenceIDs.Banks),
            let banks = try? JSONDecoder().decode([Bank].self, from: banksData) {
            return banks
        }
        
        return []
    }
    
    func getProviderBanks() -> [Bank] {
        if let banksData = UserDefaults.standard.data(forKey: PersistenceIDs.ProviderBanks),
            let banks = try? JSONDecoder().decode([Bank].self, from: banksData) {
            return banks
        }
        
        return []
    }
    
    func persistInt(value: Int, key: String) {
        delete(key: key)
        userDefaults.set(value, forKey: key);
    }
    
    func readInt(key: String) -> Int {
        userDefaults.integer(forKey: key)
    }
    
    func persistDouble(value: Double, key: String) {
        delete(key: key)
        userDefaults.set(value, forKey: key)
    }
    
    func readDouble(key: String) -> Double {
       return userDefaults.double(forKey: key)
    }
    
    func persistString(value: String, key: String) {
        delete(key: key)
        userDefaults.setValue(value, forKey: key)
    }
    
    func readString(key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    func delete(keys: String...){
        keys.forEach({delete(key: $0)})
    }
    
    func delete(key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func contains(key: String) -> Bool{
        return userDefaults.object(forKey: key) != nil
    }
    
}
