//
//  OptionalString+DefaultValue.swift
//  Project Asgard
//
//  Created by mickael ruzel on 24/11/2020.
//

import Foundation

extension Optional where Wrapped == String {
    
    var orNil: String? {
        return self?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ? nil : self
    }
    
    var orNc: String {
        return self == nil ? "N/C" : self!
    }
}
