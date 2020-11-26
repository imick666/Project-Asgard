//
//  Date+String.swift
//  Project Asgard
//
//  Created by mickael ruzel on 26/11/2020.
//

import Foundation

extension Date {
    var ddMMYY: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        
        return formatter.string(from: self)
    }
    
    var age: String {
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.month, .year, .day], from: self, to: now)
        guard let years = components.year,
              let month = components.month,
              let day = components.day else { return "N/C"}
        
        var age: String {
            if years == 0 {
                if month == 0 {
                    return "\(day) Days"
                } else {
                    return "\(month) Months"
                }
            } else {
                return "\(years) Years"
            }
        }
        
        return age
    }
}
