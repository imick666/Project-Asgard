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
            return []
        }
    }
    
    var allPuppies: [Puppy] {
        let request: NSFetchRequest<Puppy> = Puppy.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    var allTreatements: [Treatement] {
        let request: NSFetchRequest<Treatement> = Treatement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.mainContext
    }
    
    // MARK: - Mehodes
    
    func createDog(named name: String, _ affix: String,sex: Int16, birthThe date: Date, lofNumber: String?, chipNumber: String?, pitcure: Data?) {
        let newDog = Dog(context: context)
        newDog.name = name
        newDog.affix = affix
        newDog.sex = sex
        newDog.birthDate = date
        newDog.lofNumber = lofNumber
        newDog.chipNumber = chipNumber
        newDog.image = pitcure
        
        coreDataStack.saveContext()
    }
    
    func createTreatement<T: NSObject>(named name: String, startDate: Date, endDate: Date, note: String?, to: T) {
        let newTreatement = Treatement(context: context)
        newTreatement.name = name
        newTreatement.startDate = startDate
        newTreatement.endDate = endDate
        newTreatement.note = note
        if let dog = to as? Dog {
            newTreatement.toDog = dog
        }
        if let puppy = to as? Puppy {
            newTreatement.toPuppy = puppy
        }
        
        coreDataStack.saveContext()
    }
    
    func createLitter(of dog: Dog, the date: Date, cesarean: Bool, with puppies: [Puppy]) {
        let newLitter = DogLitter(context: context)
        newLitter.date = date
        newLitter.dog = dog
        newLitter.cesrean = cesarean
        puppies.forEach( {newLitter.addToPuppies(_: $0) })
        
        coreDataStack.saveContext()
    }
    
    func createPuppy(birth date: Date, sex: Int16, dogColor: String?, necklaceColor: String?) -> Puppy {
        let newPuppy = Puppy(context: context)
        newPuppy.birthDate = date
        newPuppy.sex = sex
        newPuppy.puppyColor = dogColor
        newPuppy.necklaceColor = necklaceColor
        
        
        return newPuppy
    }
    
    func deleteObject(_ object: NSManagedObject) {
        context.delete(object)
        
        coreDataStack.saveContext()
    }
}
