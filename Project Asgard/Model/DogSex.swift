//
//  DogSex.swift
//  Project Asgard
//
//  Created by mickael ruzel on 03/12/2020.
//

import Foundation

enum DogSex: Int16 {
    case male, female
    
    var description: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}
