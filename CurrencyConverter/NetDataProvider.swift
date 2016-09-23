//
//  DataProvider.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 01.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

/// скачивает из сети данные по адресу, который
/// строится из базовой строки и параметров
class NetDataProvider: NSObject {
    
    class func GET(_ URLString: String,
                   parameters: [String: String?],
                   completionBlock: @escaping (_ data: Data) -> Void,
                   errorBlock: ((_ error: Error) -> Void)?) {
        
        let requestBuilder = RequestBuilder(string: URLString)
        
        if let url = requestBuilder.url(with: parameters) {
            
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
            
            let urlSession = URLSession(configuration: configuration)
            
            let urlSessionDataTask =
                urlSession.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                    
                    if error == nil && data != nil {
                        
                        completionBlock(data!)
                        
                    } else {
                        
                        errorBlock?(error!)
                    }
            }) 
            urlSessionDataTask.resume()
            
        } else {
            
            let error =
                NSError(domain: "DOMAIN",
                        code: 999,
                        userInfo: [NSLocalizedDescriptionKey: "URL-string you proposed is incorrect"])
            
            errorBlock?(error)
        }
    }
}
