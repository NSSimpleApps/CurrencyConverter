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
    
    var url: URL?
    
    init(string: String) {
        
        super.init()
        
        self.url = URL(string: string)
    }
    
    func url(with parameters: [String: String?]) -> URL? {
        
        guard let url = self.url else { return nil }
        
        var queryItems: [URLQueryItem] = []
        
        for (name, value) in parameters {
            
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        return components?.url
    }
}
