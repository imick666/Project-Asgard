//
//  TreatementTest.swift
//  Project AsgardTests
//
//  Created by mickael ruzel on 27/11/2020.
//

import XCTest
@testable import Project_Asgard

class TreatementTest: XCTestCase {
    
    // MARK: - Properties
    
    var coreData: CoreDataManager?
    
    // MARK: - Test Life Cycle
    
    override func setUp() {
        super.setUp()
        coreData = CoreDataManager(MokeCoreDataStack())
    }
    
    override func tearDown() {
        super.tearDown()
        coreData = nil
    }

    // MARK: - Methodes
    
    private func createDog() -> Dog {
        coreData?.createDog(named: "astride", "des", sex: 0, birthThe: Date(), lofNumber: nil, chipNumber: nil, pitcure: nil)
        
        guard let dog = coreData?.allDogs[0] else {
            fatalError("Failed to create dog")
        }
        
        return dog
    }
    
    // MARK: - Tests
    
    // Create / Read
    
    func testCreateTreatement() {
        let dog = createDog()
        
        coreData?.createTreatement(named: "keto", startDate: Date(), endDate: Date(), note: nil, to: dog)
        
        XCTAssertEqual(coreData?.allDogs[0].treatements?.count, 1)
    }
    
    func testReadTreatements() {
        let dog = createDog()
        
        coreData?.createTreatement(named: "keto", startDate: Date(), endDate: Date(), note: nil, to: dog)
        
        XCTAssertEqual(coreData?.allTreatements.count, 1)
    }
    
    // Delete
    
    func testDeleteTreatement() {
        let dog = createDog()
        
        coreData?.createTreatement(named: "keto", startDate: Date(), endDate: Date(), note: nil, to: dog)
        
        guard let treatement = coreData?.allDogs[0].treatements?.allObjects[0] as? Treatement else {
            fatalError("Failed to get treatement")
        }
        
        coreData?.deleteObject(treatement)
        
        XCTAssertEqual(coreData?.allDogs[0].treatements?.count, 0)
    }

}
