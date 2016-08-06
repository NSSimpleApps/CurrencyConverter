//
//  ModelBuilder.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 02.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

private let BaseKey = "base"
private let RatesKey = "rates"

/// строит из NSData объект класса CurrencyContainer
class CurrencyContainerBuilder: NSObject {
    
    class func currencyContainer(with data: NSData) throws -> CurrencyContainer {
        
        if let dict =
        try NSJSONSerialization.JSONObjectWithData(data,
                                                   options: .AllowFragments) as? [String : AnyObject] {
            
            if let baseCurrency = dict[BaseKey] as? String, let rates = dict[RatesKey] as? [String: Float] {
                
                return CurrencyContainer(baseCurrency: baseCurrency, rates: rates)
                
            } else {
                
                throw NSError(domain: "DOMAIN",
                              code: 999,
                              userInfo: [NSLocalizedDescriptionKey: "Invalid json"])
            }
        }
        return CurrencyContainer(baseCurrency: "", rates: [:])
    }
}
