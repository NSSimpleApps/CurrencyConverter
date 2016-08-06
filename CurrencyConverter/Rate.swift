//
//  Rate.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 02.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

/// класс, который хранит пару имя-значение для валюты
class Rate: NSObject {
    
    var currency = ""
    var rate: Float = 0
    
    init(currency: String, rate: Float) {
        
        super.init()
        
        self.currency = currency
        self.rate = rate
    }
    
    override var description: String {
        
        return "Rate: currency = \(self.currency), rate = \(self.rate)"
    }
}