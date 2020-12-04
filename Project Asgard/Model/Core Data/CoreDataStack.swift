//
//  CoreDataStack.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import Foundation
import CoreData

open class CoreDataStack {
    
    // MARK: - Properties
    
    private let modelName: String
    
    // MARK: - Init
    
    public init(_ modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - CoreData
    
    public lazy var persistantContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public lazy var mainContext: NSManagedObjectContext = {
        return persistantContainer.viewContext
    }()
    
    public func saveContext() {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
