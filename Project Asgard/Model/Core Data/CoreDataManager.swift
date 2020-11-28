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
    
    var allDogs: [Dog] {
        let request: NSFetchRequest<Dog> = Dog.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        do {
            return try context.fetch(request)
        } catch {
            return [Dog]()
        }
    }
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.mainContext
    }
    
    // MARK: - Mehodes
    
    func createDog(named name: String, _ affix: String, birthThe date: Date, lofNumber: String?, chipNumber: String?, pitcure: Data?) {
        let newDog = Dog(context: context)
        newDog.name = name
        newDog.affix = affix
        newDog.birthDate = date
        newDog.lofNumber = lofNumber
        newDog.chipNumber = chipNumber
        newDog.image = pitcure
        
        coreDataStack.saveContext()
    }
    
    func createTreatement(named name: String, startDate: Date, endDate: Date, note: String?, toDog: Dog) {
        let newTreatement = Treatement(context: context)
        newTreatement.toDog = toDog
        newTreatement.name = name
        newTreatement.startDate = startDate
        newTreatement.endDate = endDate
        newTreatement.note = note
        
        coreDataStack.saveContext()
    }
    
    func deteObject(_ object: NSManagedObject) {
        context.delete(object)
        
        coreDataStack.saveContext()
    }
}