//
//  KeyboardHelper.swift
//  Project Asgard
//
//  Created by mickael ruzel on 10/12/2020.
//

import UIKit

extension UITextField {
    
    func addDoneToKeayboard() {
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        
        let flexi = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        doneToolBar.items = [flexi, doneButton]
        self.inputAccessoryView = doneToolBar
    }
    
    @objc
    private func dismissKeyboard() {
        self.resignFirstResponder()
    }
}

extension UITextView {
    
    func addDoneToKeayboard() {
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        
        let flexi = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        doneToolBar.items = [flexi, doneButton]
        self.inputAccessoryView = doneToolBar
    }
    
    @objc
    private func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
