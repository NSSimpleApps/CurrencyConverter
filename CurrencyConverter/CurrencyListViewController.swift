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
    
    fileprivate var currencyContainer = CurrencyContainer(baseCurrency: "", rates: [:])
    
    fileprivate var amount: Float = 1
    
    fileprivate var digitalFilter: DigitalFilter!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.registerCell(for: CurrencyCell.self)
        
        self.topTextField.text = String(self.amount)
        
        self.digitalFilter = DigitalFilter(textField: self.topTextField)
        self.digitalFilter.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.currencyContainer.currencyList.count
        
        if count == 0 {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
            label.text = "No data"
            label.textColor = UIColor.black
            label.numberOfLines = 1
            label.textAlignment = .center
            label.sizeToFit()
            
            tableView.backgroundView = label
            tableView.separatorStyle = .none
            
        } else {
            
            self.tableView.separatorStyle = .singleLine
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyCell.self), for: indexPath)
        cell.textLabel?.text = self.currencyContainer.currencyList[row]
        cell.detailTextLabel?.text =
            self.formattedTitle(for: self.currencyContainer.currencyValue(for: row, amount: self.amount))
        
        return cell
    }
    
    @IBAction func updateCurrencyList(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let parameters: [String: String?]
        
        if self.currencyContainer.baseCurrency.isEmpty {
            
            parameters = [:]
            
        } else {
            
            parameters = ["base": self.currencyContainer.baseCurrency]
        }
        
        CurrencyDataProvider.GET("http://api.fixer.io/latest",
                                 parameters: parameters,
                                 completionBlock: { [weak self] (currencyContainer) in
                                    
                                    if let sSelf = self {
                                        
                                        sSelf.navigationItem.rightBarButtonItem?.isEnabled = true
                                        sSelf.navigationItem.rightBarButtonItem?.title = currencyContainer.baseCurrency
                                        sSelf.currencyContainer = currencyContainer
                                        sSelf.tableView.reloadData()
                                        
                                        sender.isEnabled = true
                                    }
        }) { [weak self] (error) in
            
            if let sSelf = self {
                
                let alertController =
                    UIAlertController(title: error.localizedDescription, cancelTitle: "Close")
                
                sSelf.present(alertController, animated: true, completion: {
                    
                    sSelf.navigationItem.rightBarButtonItem?.isEnabled = true
                    sender.isEnabled = true
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChangeBaseCurrencySegue" {
            
            let nc = segue.destination as! UINavigationController
            
            var currencyList = self.currencyContainer.currencyList
            currencyList.append(self.currencyContainer.baseCurrency)
            currencyList.sort()
            
            let baseCurrencyController = nc.topViewController as! SelectBaseCurrencyController
            baseCurrencyController.currencyList = currencyList
            baseCurrencyController.selectedIndex = currencyList.index(of: self.currencyContainer.baseCurrency)
            baseCurrencyController.delegate = self
        }
    }
    
    fileprivate func formattedTitle(for currencyValue: Float) -> String {
        
        return String(format: "%.04f", currencyValue)
    }
}

extension CurrencyListViewController: DigitalFilterDelegate {
    
    func digitalFilter(_ digitalFilter: DigitalFilter,
                       shouldChangeDigitalString string: String) -> Bool {
        
        self.amount = Float(string) ?? 0
        
        return !string.hasPrefix(".")
    }
    
    func digitalFilter(_ digitalFilter: DigitalFilter,
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
