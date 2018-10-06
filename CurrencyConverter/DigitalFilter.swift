//
//  DigitalFilter.swift
//  CurrencyConverter
//
//  Created by NSSimpleApps on 04.08.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

import UIKit

protocol DigitalFilterDelegate: class {
    
    func digitalFilter(_ digitalFilter: DigitalFilter,
                       shouldChangeDigitalString string: String) -> Bool
    
    func digitalFilter(_ digitalFilter: DigitalFilter,
                       textFieldShouldReturn textField: UITextField) -> Bool
}

/// фильтрует ввод в UITextField и прокидывает для делегата
/// строку, которую можно перевести в число
class DigitalFilter: NSObject, UITextFieldDelegate {
    weak var delegate: DigitalFilterDelegate?
    
    var textField: UITextField? {
        didSet {
            self.textField?.delegate = self
            
            if !self.testString(self.textField?.text ?? "") {
                self.textField?.text = ""
            }
        }
    }
    
    init(textField: UITextField) {
        super.init()
        ({ self.textField = textField })()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let stringToReplace = self.stringToReplace(textField.text, string: string, range: range)
        
        let result = self.testString(stringToReplace)
        
        if result {
            return self.delegate?.digitalFilter(self, shouldChangeDigitalString: stringToReplace) ?? false
            
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let shouldReturn = self.delegate?.digitalFilter(self, textFieldShouldReturn: textField) {
            return shouldReturn
        }
        return false
    }
    
    private func stringToReplace(_ text: String?, string: String, range: NSRange) -> String {
        if let text = text {
            return (text as NSString).replacingCharacters(in: range, with: string)
            
        } else {
            return string
        }
    }
    
    private func testString(_ string: String) -> Bool {
        let regex = "\\d*(\\.)?\\d{0,2}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: string)
    }
}
