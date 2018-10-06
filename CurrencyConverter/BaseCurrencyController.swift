//
//  BaseCurrencyController.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 04.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

protocol SelectBaseCurrencyDelegate: AnyObject {
    func selectionDidEnd(with index: Int, currency: String)
}

/// выбор базовой валюты
class SelectBaseCurrencyController: UITableViewController {
    var currencyList: [String] = []
    var selectedIndex: Int?
    weak var delegate: SelectBaseCurrencyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerCell(for: CurrencyCell.self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.currencyList.count
        
        if count == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
            label.text = "No data"
            label.textColor = UIColor.black
            label.numberOfLines = 1
            label.textAlignment = .center
            label.sizeToFit()
            
            tableView.backgroundView = label
            
        } else {
            tableView.backgroundView = nil
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyCell.self),
                                                               for: indexPath)
        cell.textLabel?.text = self.currencyList[row]
        cell.detailTextLabel?.text = nil
        
        if row == self.selectedIndex {
            cell.accessoryType = .checkmark
            
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if let selectedIndex = self.selectedIndex , row != selectedIndex {
            let prevIndexPath = IndexPath(row: selectedIndex, section: 0)
            tableView.cellForRow(at: prevIndexPath)?.accessoryType = .none
        }
        self.selectedIndex = row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        if let index = self.selectedIndex {
            let delegate = self.delegate
            let currency = self.currencyList[index]
            
            self.dismiss(animated: true) {
                delegate?.selectionDidEnd(with: index, currency: currency)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
