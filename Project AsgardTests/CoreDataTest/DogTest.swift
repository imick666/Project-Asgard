//
//  DogTest.swift
//  Project AsgardTests
//
//  Created by mickael ruzel on 23/11/2020.
//

import XCTest
@testable import Project_Asgard

class DogTest: XCTestCase {

    // MARK: - Properties
    
    var coreDataStack: CoreDataStack!
    var coreDataManager: CoreDataManager!
    
    // MARK: - Test Life Cycle
    
    override func setUp() {
        super.setUp()
        coreDataStack = MokeCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }
    
    // MARK: - Tests

    // Create / Read
    
    func testCreateDog() {
        coreDataManager.createDog(named: "fidjy", "de la baracine", sex: 0, birthThe: Date(), lofNumber: nil, chipNumber: nil, pitcure: nil)
        
        XCTAssertEqual(coreDataManager.allDogs.count, 1)
    }
    
    // Delete
    
    func testDeleteObject() {
        coreDataManager.createDog(named: "fidjy", "de la baracine", sex: 0, birthThe: Date(), lofNumber: nil, chipNumber: nil, pitcure: nil)
        
        let dog = coreDataManager.allDogs[0]
        
        coreDataManager.deteObject(dog)
        
        XCTAssertEqual(coreDataManager.allDogs.count, 0)
    }
}
