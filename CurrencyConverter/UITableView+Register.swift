//
//  UITableView+Register.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 04.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

/// разширение для UITableView, которое регистрирует
/// ячейку с именем UINib и ReuseIndentifier, которые
/// равны имени класса ячейки
extension UITableView {
    
    func registerCell(for cellClass: UITableViewCell.Type) {
        
        let reuseIdentifier = String(describing: cellClass)
        
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        
        self.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}
