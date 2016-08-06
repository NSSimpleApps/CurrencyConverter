//
//  RequestBuilder.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 01.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

/// строит из базовой строки и параметров NSURL
class RequestBuilder: NSObject {
    
    var URL: NSURL?
    
    init(string: String) {
        
        super.init()
        
        self.URL = NSURL(string: string)
    }
    
    func URL(with parameters: [String: String?]) -> NSURL? {
        
        guard let URL = self.URL else { return nil }
        
        var queryItems: [NSURLQueryItem] = []
        
        for (name, value) in parameters {
            
            queryItems.append(NSURLQueryItem(name: name, value: value))
        }
        
        let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        return components?.URL
    }
}
