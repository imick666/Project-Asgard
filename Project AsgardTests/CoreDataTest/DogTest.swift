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

}
