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
class CurrencyContainerBuilder {
    struct Info: Decodable {
        let base: String
        let rates: [String: Float]
    }
    class func currencyContainer(with data: Data) throws -> CurrencyContainer {
        let info = try JSONDecoder().decode(Info.self, from: data)
        return CurrencyContainer(baseCurrency: info.base, rates: info.rates)
    }
}
