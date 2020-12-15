//
//  UIColor+String.swift
//  Project Asgard
//
//  Created by mickael ruzel on 15/12/2020.
//

import UIKit

extension UIColor {
    
    convenience init?(fromHex hexString: String?) {
        guard let hexNormalized = hexString?.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "#", with: "") else {
            return nil
        }
        
        // Helper
        var rgb: UInt32 = 0
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1.0
        let length = hexNormalized.count
        
        // Create scanner
        Scanner(string: hexNormalized).scanHexInt32(&rgb)
        
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var toHex: String? {
        // extract Components
        guard let components = cgColor.components, components.count >= 3 else { return nil }
        
        // Helpers
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        var alpha = Float(1.0)
        
        if components.count >= 4 {
            alpha = Float(components[3])
        }
        
        // Create hex string
        let hex = String(format: "%02lX%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255), lroundf(alpha * 255))
        
        print(hex)
        return hex
    }
    
}
