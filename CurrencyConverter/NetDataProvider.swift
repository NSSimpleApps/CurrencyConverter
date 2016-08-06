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
    
    class func GET(URLString: String,
                   parameters: [String: String?],
                   completionBlock: (data: NSData) -> Void,
                   errorBlock: ((error: NSError) -> Void)?) {
        
        let requestBuilder = RequestBuilder(string: URLString)
        
        if let URL = requestBuilder.URL(with: parameters) {
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            configuration.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
            
            let URLSession = NSURLSession(configuration: configuration)
            
            let URLSessionDataTask =
                URLSession.dataTaskWithURL(URL) { (data: NSData?, URLResponse: NSURLResponse?, error: NSError?) -> Void in
                    
                    if error == nil && data != nil {
                        
                        completionBlock(data: data!)
                        
                    } else {
                        
                        errorBlock?(error: error!)
                    }
            }
            URLSessionDataTask.resume()
            
        } else {
            
            let error =
                NSError(domain: "DOMAIN",
                        code: 999,
                        userInfo: [NSLocalizedDescriptionKey: "URL-string you proposed is incorrect"])
            
            errorBlock?(error: error)
        }
    }
}
