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
class CurrencyDataProvider: NSObject {
    
    class func GET(URLString: String,
                   parameters: [String: String?],
                   completionBlock: (currencyContainer: CurrencyContainer) -> Void,
                   errorBlock: ((error: NSError) -> Void)?) {
        
        NetDataProvider.GET(URLString,
                            parameters: parameters,
                            completionBlock: { (data: NSData) in
                                
                                do {
                                    
                                    let currencyContainer =
                                        try CurrencyContainerBuilder.currencyContainer(with: data)
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        completionBlock(currencyContainer: currencyContainer)
                                    })
                                    
                                } catch let error as NSError {
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        errorBlock?(error: error)
                                    })
                                }
                                
        }) { (error: NSError) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    errorBlock?(error: error)
                })
        }
    }
}
