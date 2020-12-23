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
        coreData?.createDog(named: "Asride", "", sex: 0, dogColor: nil, birthThe: Date(), lofNumber: nil, chipNumber: nil, pitcure: nil)
        
        guard let dog = coreData?.allDogs[0] else {
            fatalError("Failed to create dog")
        }
        
        return dog
    }
    
    private func createPuppies(_ number: Int) -> [Puppy] {
        var puppies = [Puppy]()
        
        for _ in 0..<number {
            let puppy = coreData.createPuppy(named: nil, affix: nil, birthThe: Date(), sex: 1, dogColor: nil, necklaceColor: nil, image: nil)
            puppies.append(puppy)
        }
        
        return puppies
    }
    
    // MARK: - Tests
    
    // Create / Read
    
    func testCreateLitter(){
        var dog = creatDog()
        let puppies = createPuppies(5)
        
        coreData.createLitter(of: dog, the: Date(), cesarean: true, with: puppies)
        
        dog = coreData.allDogs[0]
        let litter = dog.litters?.allObjects as! [DogLitter]
        
        XCTAssertEqual(litter.count, 1)
        XCTAssertEqual(litter[0].puppies?.count, 5)
    }
    
    func testReadPuppies() {
        let dog = creatDog()
        let puppies = createPuppies(2)
        
        coreData.createLitter(of: dog, the: Date(), cesarean: false, with: puppies)
        
        XCTAssertEqual(coreData.allPuppies.count, 2)
    }
    
    // Updtae
    
    func testUpdatePuppy() {
        let dog = creatDog()
        let puppies = createPuppies(1)
        
        coreData.createLitter(of: dog, the: Date(), cesarean: true, with: puppies)
        
        var puppy: Puppy {
            return coreData.allPuppies[0]
        }
        
        coreData.update(puppy: puppy, value: [("astride de ouf", "name")])
        
        XCTAssertEqual(puppy.name, "astride de ouf")
    }
    
    // Delete
    
    func testDeletePuppyInLitter() {
        var dog = creatDog()
        let puppies = createPuppies(5)
        
        coreData?.createLitter(of: dog, the: Date(), cesarean: true, with: puppies)
        dog = coreData.allDogs[0]
        var dogLitter: [DogLitter] {
            return dog.litters?.allObjects as! [DogLitter]
        }
        var dogPuppies: [Puppy] {
            return dogLitter[0].puppies?.allObjects as! [Puppy]
        }
        
        XCTAssertEqual(dogPuppies.count, 5)
        
        coreData.deleteObject(dogPuppies[0])
        
        dog = coreData.allDogs[0]
        
        XCTAssertEqual(dogPuppies.count, 4)
        
    }
    
    func testAutoDeleteLitter() {
        var dog = creatDog()
        let puppies = createPuppies(1)
        
        coreData.createLitter(of: dog, the: Date(), cesarean: false, with: puppies)
        var dogLitter: [DogLitter] {
            return dog.litters?.allObjects as! [DogLitter]
        }
        var dogPuppies: [Puppy] {
            return dogLitter[0].puppies?.allObjects as! [Puppy]
        }
        
        XCTAssertEqual(dogPuppies.count, 1)
        
        coreData.deleteObject(dogPuppies[0])
        dog = coreData.allDogs[0]
        
        XCTAssertEqual(dogLitter.count, 0)
        
    }
}
