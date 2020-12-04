//
//  Treatement+PuppyTests.swift
//  Project AsgardTests
//
//  Created by mickael ruzel on 04/12/2020.
//

import XCTest
@testable import Project_Asgard

class Treatement_PuppyTests: XCTestCase {
    
    // MARK: - Properties

    var coreData: CoreDataManager!
    
    // MARK: - Init
    
    override func setUp() {
        super.setUp()
        coreData = CoreDataManager(MokeCoreDataStack())
    }
    
    override func tearDown() {
        super.tearDown()
        coreData = nil
    }
    
    // MARK: - Methodes
    
    private func createDogAndPuppy() -> Dog {
        coreData.createDog(named: "Astride", "", sex: 0, birthThe: Date(), lofNumber: nil, chipNumber: nil, pitcure: nil)
        
        let dog = coreData.allDogs[0]
        let puppy = coreData.createPuppy(birth: Date(), sex: 1, dogColor: nil)
        coreData.createLitter(of: dog, the: Date(), cesarean: true, with: [puppy])
        
        guard let _ = ((coreData.allDogs[0].litter?.allObjects[0] as? DogLitter)?.puppies?.allObjects as? [Puppy])?[0] else {
            fatalError("Failed to create dog and puppy")
        }
        
        return coreData.allDogs[0]
    }

    // MARK: - Tests
    
    // Create / Read
    
    func testCreateTreatement() {
        var dog = createDogAndPuppy()
        var litter: DogLitter {
            return dog.litter?.allObjects[0] as! DogLitter
        }
        var puppy: Puppy {
            return litter.puppies?.allObjects[0] as! Puppy
        }
        var puppyTreatement: [Treatement] {
            return puppy.treatements?.allObjects as! [Treatement]
        }
        
        coreData.createTreatement(named: "ketoprophenide", startDate: Date(), endDate: Date(), note: nil, to: puppy)
        
        dog = coreData.allDogs[0]
        
        XCTAssertEqual(dog.treatements?.count, 0)
        XCTAssertEqual(puppyTreatement.count, 1)
    }
    
    // Update
    
    // Delete
    
    func testDeleteTreatement() {
        var dog = createDogAndPuppy()
        var litter: DogLitter {
            return dog.litter?.allObjects[0] as! DogLitter
        }
        var puppy: Puppy {
            return litter.puppies?.allObjects[0] as! Puppy
        }
        var treatement: [Treatement] {
            return puppy.treatements?.allObjects as! [Treatement]
        }
        
        coreData.createTreatement(named: "keyto", startDate: Date(), endDate: Date(), note: nil, to: puppy)
        dog = coreData.allDogs[0]
        XCTAssertEqual(treatement.count, 1)
        
        coreData.deteObject(treatement[0])
        dog = coreData.allDogs[0]
        XCTAssertEqual(treatement.count, 0)
    }
}
