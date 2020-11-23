//
//  MokeCoreDataStack.swift
//  Project AsgardTests
//
//  Created by mickael ruzel on 23/11/2020.
//

import Foundation
import CoreData
import Project_Asgard

final class MokeCoreDataStack: CoreDataStack {
    
    // MARK: - Init
    
    convenience init() {
        self.init("Project_Asgard")
    }
    
    override init(_ modelName: String) {
        super.init(modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistantContainer = container
    }
}
