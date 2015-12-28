//
//  Larkspur_FerryUITests.swift
//  Larkspur FerryUITests
//
//  Created by Gareth Jones on 12/20/15.
//  Copyright © 2015 gpj. All rights reserved.
//

import XCTest

class Larkspur_FerryUITests: XCTestCase {
        
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
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        XCUIDevice.sharedDevice().orientation = .Portrait
        sleep(2)
        
        //app.alerts.element.collectionViews.buttons["Allow"].tap()
        // Snap Main Screen
        snapshot("01MainScreen")
        
        // Select a cell to swipe
        XCUIApplication().tables.cells.containingType(.StaticText, identifier:"8:30 AM").staticTexts["San Francisco to Larkspur"].swipeUp()
        
        // Take second screen shot
        snapshot("02FerryScreen")
        
        // Take third screenshot
        snapshot("03FerryScreen")
        
        // need to sleep before tapping
        sleep(3)
        
        // Tap one of the ferry times
        app.tables.cells.containingType(.StaticText, identifier:"10:10 AM").staticTexts["San Francisco to Larkspur"].tap()
        
        // sleep to enable map to render
        sleep(8)
        // Take screenshot of map
        snapshot("04MapScreen")
        snapshot("05MapScreen")
        

        
        
        
    }
    
}
