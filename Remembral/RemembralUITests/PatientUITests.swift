//
//  PatientUITests.swift
//  RemembralUITests
//
//  Created by Alwin Leong on 11/3/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import XCTest

class PatientUITests: XCTestCase {
    
    let randomNames = ["Patient", "RANDOMNAME", "PatientName"]
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testModifyUserFields() {
        let app = XCUIApplication()
        let nameToEnter = "Patient" + randomString(length: 10)
        
        app.buttons["Patient"].tap()
        
        sleep(5)
        
        app.buttons["Edit"].tap()
        
        let textField = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element(boundBy: 0)
        
        textField.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: (textField.value as! String).count)
        textField.typeText(deleteString)
        textField.typeText(nameToEnter + "\n")
        let newName = textField.value as! String
        
        app.buttons["Done"].tap()
        

        XCTAssertNotNil(app.cells[newName]) //New name has been set correctly
        
    }
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}
