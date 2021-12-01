//
//  CityAirUITests.swift
//  CityAirUITests
//
//  Created by Ajeet Pratap Maurya on 27/11/21.
//

import XCTest

class CityAirUITests: XCTestCase {

    var app: XCUIApplication!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        
    }
    
    func testCityTableView() {
        let tableView = app.tables["CityTable"]
        XCTAssertTrue(tableView.exists,"City Table rendered")
        let tableViewCells = tableView.cells
        guard tableViewCells.count > 0 else {
            XCTAssert(false, "No cell found")
            return
        }
        let cellValidation = expectation(description: "Cell Validation")
        let cellCount = tableViewCells.count - 1
        for i in stride(from: 0, to: cellCount , by: 1) {
            let cell = tableViewCells.element(boundBy: i)
            while !cell.exists {
                app.swipeUp()
                continue
            }
            XCTAssertTrue(cell.exists, "cell found at \(i)")
            cell.tap()
            if i == cellCount - 1 {
                cellValidation.fulfill()
            }
            app.navigationBars["CityAir.CityDetailView"].buttons["City Air"].tap()
            
                        
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(true, "Cells Validated")
        
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
