//
//  RepositoryTests.swift
//  RepositoryTests
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import XCTest
@testable import Repository

class RepositoryTests: XCTestCase {

    var manager:Manager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.manager = Manager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCountCardsWithNil(){
        let cards = self.manager.getCards()

        XCTAssertNil(cards?.count, "comparation")
    }
    
    func testCountCards(){
        let cards = self.manager.getCards()        
        XCTAssertNotNil(cards)
    }
    
}
