//
//  Litter&PuppyTest.swift
//  Project AsgardTests
//
//  Created by mickael ruzel on 02/12/2020.
//

import XCTest
@testable import Project_Asgard

class Litter_PuppyTest: XCTestCase {

    private var coreData: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreData = CoreDataManager(MokeCoreDataStack())
    }
    
    override func tearDown() {
        super.tearDown()
        coreData = nil
    }
    
    private func creatDog() -> Dog {
        coreData?.createDog(named: "Asride", "", birthThe: Date(), lofNumber: nil, chipNumber: nil, pitcure: nil)
        
        guard let dog = coreData?.allDogs[0] else {
            fatalError("Failed to create dog")
        }
        
        return dog
    }
    
    private func createPuppies(_ number: Int) -> [Puppy] {
        var puppies = [Puppy]()
        
        for _ in 0..<number {
            let puppy = coreData.createPuppy(birth: Date(), sex: "male", dogColor: nil)
            puppies.append(puppy)
        }
        
        return puppies
    }
    
    // MARK: - Tests
    
    // Create / Read
    
    func testCreateLitter(){
        var dog = creatDog()
        let puppies = createPuppies(5)
        
        coreData?.createLitter(of: dog, the: Date(), with: puppies)
        
        dog = coreData!.allDogs[0]
        
        let dogLitter = dog.litter!.allObjects as! [DogLitter]
        
        XCTAssertEqual(dogLitter.count, 1)
        XCTAssertEqual(dogLitter[0].puppies?.count, 5)
    }
    
    // Updtae
    
    
    // Delete
    
    func testDeletePuppyInLitter() {
        var dog = creatDog()
        let puppies = createPuppies(5)
        
        coreData?.createLitter(of: dog, the: Date(), with: puppies)
        dog = coreData.allDogs[0]
        var dogLitter: [DogLitter] {
            return dog.litter?.allObjects as! [DogLitter]
        }
        var dogPuppies: [Puppy] {
            return dogLitter[0].puppies?.allObjects as! [Puppy]
        }
        
        XCTAssertEqual(dogPuppies.count, 5)
        
        coreData.deteObject(dogPuppies[0])
        
        dog = coreData.allDogs[0]
        
        XCTAssertEqual(dogPuppies.count, 4)
        
    }
}
