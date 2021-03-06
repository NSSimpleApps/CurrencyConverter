//
//  CurrencyDataProvider.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 05.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

/// скачивает из сети NSData и строит CurrencyContainer
/// обрабатывает ошибки и выполняет блоки в главном потоке
class CurrencyDataProvider {
    
    class func GET(_ URLString: String,
                   parameters: [String: String?],
                   completionBlock: @escaping (_ currencyContainer: CurrencyContainer) -> Void,
                   errorBlock: @escaping (_ error: Error) -> Void) {
        NetDataProvider.GET(URLString, parameters: parameters,
                            completionBlock: { (data) in
                                do {
                                    let currencyContainer = try CurrencyContainerBuilder.currencyContainer(with: data)
                                    DispatchQueue.main.async(execute: {
                                        completionBlock(currencyContainer)
                                    })
                                } catch let error as NSError {
                                    DispatchQueue.main.async(execute: {
                                        errorBlock(error)
                                    })
                                }
        }, errorBlock: { (error: Error) in
            DispatchQueue.main.async(execute: {
                errorBlock(error)
            })
        })
    }
}
