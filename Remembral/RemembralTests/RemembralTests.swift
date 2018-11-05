//
//  RemembralTests.swift
//  RemembralTests
//
//  Created by Alwin Leong on 11/3/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//
//  Tests for general functions of the application

import XCTest
@testable import Remembral
@testable import FirebaseAuth


class RemembralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthenticationCaretaaker() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateInitialViewController() as! UserSelectorViewController
        XCTAssertNotNil(login)
        let _ = login.view
        login.onUserCaretaker(self)
        
        sleep(3)
        
        XCTAssert(Auth.auth().currentUser?.uid != nil)
    }
    
    func testAuthenticationPatient() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateInitialViewController() as! UserSelectorViewController
        XCTAssertNotNil(login)
        let _ = login.view
        login.onUserPtient(self)
        
        sleep(3)
        
        XCTAssert(Auth.auth().currentUser?.uid != nil)
    }
    /*
    func testAuthenticationSpeed() {

        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}
