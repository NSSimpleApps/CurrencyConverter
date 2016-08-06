//
//  BaseCurrencyController.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 04.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

protocol SelectBaseCurrencyDelegate: class {
    
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.currencyList.count
        
        if count == 0 {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
            label.text = "No data"
            label.textColor = UIColor.blackColor()
            label.numberOfLines = 1
            label.textAlignment = .Center
            label.sizeToFit()
            
            tableView.backgroundView = label
            tableView.separatorStyle = .None
            
        } else {
            
            self.tableView.separatorStyle = .SingleLine
        }
        
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(CurrencyCell),
                                                               forIndexPath: indexPath)
        cell.textLabel?.text = self.currencyList[row]
        cell.detailTextLabel?.text = nil
        
        if row == self.selectedIndex {
            
            cell.accessoryType = .Checkmark
            
        } else {
            
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        
        if let selectedIndex = self.selectedIndex where row != selectedIndex {
            
            let prevIndexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
            
            tableView.cellForRowAtIndexPath(prevIndexPath)?.accessoryType = .None
        }
        
        self.selectedIndex = row
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
    }
    
    @IBAction func dismissAction(sender: UIBarButtonItem) {
        
        if let index = self.selectedIndex {
            
            let delegate = self.delegate
            let currency = self.currencyList[index]
            
            self.dismissViewControllerAnimated(true) {
                
                delegate?.selectionDidEnd(with: index, currency: currency)
            }
            
        } else {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
