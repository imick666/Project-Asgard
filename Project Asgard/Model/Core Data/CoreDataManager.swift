//
//  CoreDataManager.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.mainContext
    }
    
    // MARK: - Mehodes
    
}
