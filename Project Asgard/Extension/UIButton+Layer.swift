//
//  UIButton+Layer.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

extension UIButton {
    
    func roundFilled(wih color: UIColor?) {
        self.layer.cornerRadius = self.frame.height / 2
        guard let color = color else { return }
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
        self.setTitleColor(color, for: .normal)
    }
    
}
