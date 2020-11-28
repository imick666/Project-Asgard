//
//  UIAlertController+setValues.swift
//  Project Asgard
//
//  Created by mickael ruzel on 28/11/2020.
//

import UIKit

extension UIAlertController {
    
    func setContentViewController(_ viewController: UIViewController) {
        self.setValue(viewController, forKey: "contentViewController")
    }
    
    func setTitle(_ title: String, font: UIFont?, titleColor: UIColor?) {
        var attributedString = [NSAttributedString.Key: Any]()
        if let font = font { attributedString[.font] = font }
        if let titleColor = titleColor { attributedString[.foregroundColor] = titleColor }
        
        let finalTitle = NSMutableAttributedString(string: title, attributes: attributedString)
        
        self.setValue(finalTitle, forKey: "attributedTitle")
    }
    
}
