//
//  RequestBuilder.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 01.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import Foundation

/// строит из базовой строки и параметров NSURL
class RequestBuilder {
    let url: URL?
    
    init(string: String) {
        self.url = URL(string: string)
    }
    
    func url(with parameters: [String: String?]) -> URL? {
        guard let url = self.url else { return nil }
        
        let queryItems = parameters.map { (elem) -> URLQueryItem in
            URLQueryItem(name: elem.key, value: elem.value)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if let items = components?.queryItems {
            components?.queryItems = items + queryItems
        } else {
            components?.queryItems = queryItems
        }
        
        return components?.url
    }
}
