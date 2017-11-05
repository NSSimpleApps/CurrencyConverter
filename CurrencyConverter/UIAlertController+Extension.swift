//
//  UIAlertController+Extension.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 02.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

/// разширение для UIAlertController, которое упрощает 
/// создание простого алерта с кнопкой отмены
extension UIAlertController {
    
    convenience init(title: String, cancelTitle: String) {
        
        self.init(title: title, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle,
                                         style: .cancel,
                                         handler: nil)
        
        self.addAction(cancelAction)
    }
}
