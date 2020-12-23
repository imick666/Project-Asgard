//
//  Puppy+WeightsTests.swift
//  Project AsgardTests
//
//  Created by mickael ruzel on 21/12/2020.
//

import XCTest
@testable import Project_Asgard

class Puppy_WeightsTests: XCTestCase {

    // MARK: - Properties
    
    var coreData: CoreDataManager!
    
    // MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        coreData = CoreDataManager(MokeCoreDataStack())
    }
    
    override func tearDown() {
        super.tearDown()
        coreData = nil
    }
    
    // MARK: - Methodes
    
    func createDogAndPuppy() -> Puppy {
        coreData.createDog(named: "astride", "", sex: 1, dogColor: nil, birthThe: Date(), lofNumber: nil, chipNumber: nil, pitcure: nil)
        
        var dog: Dog {
            return coreData.allDogs[0]
        }
        
        let puppy = coreData.createPuppy(named: nil, affix: nil, birthThe: Date(), sex: 1, dogColor: nil, necklaceColor: nil, image: nil)
        
        coreData.createLitter(of: dog, the: Date(), cesarean: false, with: [puppy])
        
        return coreData.allPuppies[0]
    }
    
    // MARK: - Tests
    
    func testWriteAndRead() {
        let newPupy = createDogAndPuppy()
        
        coreData?.createWeight(for: newPupy, date: Date(), weight: 2)
        
        var puppy: Puppy {
            return coreData.allPuppies[0]
        }
        
        XCTAssertEqual(puppy.weights?.count, 1)
    }
}
