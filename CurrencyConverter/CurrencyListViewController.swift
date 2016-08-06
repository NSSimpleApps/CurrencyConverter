//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 01.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

/// главный контроллер для отображения списка валют
class CurrencyListViewController: UITableViewController {
    
    @IBOutlet weak var topTextField: UITextField!
    
    private var currencyContainer = CurrencyContainer(baseCurrency: "", rates: [:])
    
    private var amount: Float = 1
    
    private var digitalFilter: DigitalFilter!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.registerCell(for: CurrencyCell.self)
        
        self.topTextField.text = String(self.amount)
        
        self.digitalFilter = DigitalFilter(textField: self.topTextField)
        self.digitalFilter.delegate = self
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.currencyContainer.currencyList.count
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(CurrencyCell), forIndexPath: indexPath)
        cell.textLabel?.text = self.currencyContainer.currencyList[row]
        cell.detailTextLabel?.text =
            self.formattedTitle(for: self.currencyContainer.currencyValue(for: row, amount: self.amount))
        
        return cell
    }
    
    @IBAction func updateCurrencyList(sender: UIBarButtonItem) {
        
        sender.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        let parameters: [String: String?]
        
        if self.currencyContainer.baseCurrency.isEmpty {
            
            parameters = [:]
            
        } else {
            
            parameters = ["base": self.currencyContainer.baseCurrency]
        }
        
        CurrencyDataProvider.GET("http://api.fixer.io/latest",
                                 parameters: parameters,
                                 completionBlock: { (currencyContainer) in
                                    
                                    self.navigationItem.rightBarButtonItem?.enabled = true
                                    self.navigationItem.rightBarButtonItem?.title = currencyContainer.baseCurrency
                                    self.currencyContainer = currencyContainer
                                    self.tableView.reloadData()
                                    
                                    sender.enabled = true
        }) { (error) in
            
            let alertController =
                UIAlertController(title: error.localizedDescription, cancelTitle: "Close")
            
            self.presentViewController(alertController, animated: true, completion: {
                
                self.navigationItem.rightBarButtonItem?.enabled = true
                sender.enabled = true
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChangeBaseCurrencySegue" {
            
            let nc = segue.destinationViewController as! UINavigationController
            
            var currencyList = self.currencyContainer.currencyList
            currencyList.append(self.currencyContainer.baseCurrency)
            currencyList.sortInPlace()
            
            let baseCurrencyController = nc.topViewController as! SelectBaseCurrencyController
            baseCurrencyController.currencyList = currencyList
            baseCurrencyController.selectedIndex = currencyList.indexOf(self.currencyContainer.baseCurrency)
            baseCurrencyController.delegate = self
        }
    }
    
    private func formattedTitle(for currencyValue: Float) -> String {
        
        return String(format: "%.04f", currencyValue)
    }
}

extension CurrencyListViewController: DigitalFilterDelegate {
    
    func digitalFilter(digitalFilter: DigitalFilter,
                       shouldChangeDigitalString string: String) -> Bool {
        
        self.amount = Float(string) ?? 0
        
        return !string.hasPrefix(".")
    }
    
    func digitalFilter(digitalFilter: DigitalFilter,
                       textFieldShouldReturn textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        self.tableView.reloadData()
        
        return true
    }
}

extension CurrencyListViewController: SelectBaseCurrencyDelegate {
    
    func selectionDidEnd(with index: Int, currency: String) {
        
        self.navigationItem.rightBarButtonItem?.title = currency
        self.currencyContainer.baseCurrency = currency
        self.tableView.reloadData()
    }
}