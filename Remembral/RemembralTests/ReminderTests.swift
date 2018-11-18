//
//  ReminderTests.swift
//  RemembralTests
//
//  Created by Alwin Leong on 11/3/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import XCTest
@testable import Remembral


class ReminderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetLocationEvents() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateInitialViewController() as! UserSelectorViewController
        XCTAssertNotNil(login)
        let _ = login.view
        login.onUserCaretaker(self)
        
        sleep(3)
        let testExpect = XCTestExpectation(description: "Download all the patient's events")
        LocationServicesHandler.readLocations(forID: "iKbAZiqWylPvVNkOLPlYfzyuzan2", startingPoint: 0) {
            (result) in
            print(result)
            testExpect.fulfill()
        }
        
        wait(for: [testExpect], timeout: 10.0)
        
    }
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}
