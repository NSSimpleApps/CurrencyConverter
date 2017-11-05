//
//  CurrencyContainer.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 02.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

/// класс, который отвечает за хранение списка валюты и конвертацию
class CurrencyContainer: NSObject {
    
    fileprivate var baseRate = Rate(currency: "", rate: 1)
    fileprivate var rates: [String: Float] = [:]
    fileprivate var sortedKeys: [String] = []
    
    init(baseCurrency: String, rates: [String: Float]) {
        
        super.init()
        
        self.rates = rates
        
        self.privateInit(with: baseCurrency)
    }
    
    fileprivate func privateInit(with baseCurrency: String) {
    
        if let baseCurrencyValue = self.rates.removeValue(forKey: baseCurrency) {
            
            self.baseRate = Rate(currency: baseCurrency, rate: baseCurrencyValue)
            
        } else {
            
            self.baseRate = Rate(currency: baseCurrency, rate: 1)
        }
        
        self.sortedKeys = self.rates.keys.sorted()
    }
    
    var currencyList: [String] {
        
        return self.sortedKeys
    }
    
    @nonobjc func currencyValue(for index: Int, amount: Float) -> Float {
        
        if self.baseRate.rate == 0 {
            
            return 0
            
        } else {
            
            let rate = self.rates[self.sortedKeys[index]]!
            
            return amount * rate / self.baseRate.rate
        }
    }
    
    @nonobjc func currencyValue(for currency: String, amount: Float) -> Float {
        
        if let rate = self.rates[currency] , self.baseRate.rate != 0 {
            
            return amount * rate / self.baseRate.rate
            
        } else {
            
            return 0
        }
    }
    
    var baseCurrency: String {
        
        get {
            
            return self.baseRate.currency
        }
        
        set {
            
            if self.baseRate.currency != newValue {
                
                self.rates[self.baseRate.currency] = self.baseRate.rate
                
                self.privateInit(with: newValue)
            }
        }
    }
}
