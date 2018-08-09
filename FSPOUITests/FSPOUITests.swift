//
//  FSPOUITests.swift
//  FSPOUITests
//
//  Created by Николай Борисов on 09/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import XCTest

class FSPOUITests: XCTestCase {
    let currentMonth = "August"
    let swipeDownMonth = "February"
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testJournalModule() {
        let app = XCUIApplication()
        app.tabBars.buttons["Journal"].tap()
        let moreButton = app.buttons["More"]
        _ = moreButton.waitForExistence(timeout: 5)
        let byDateButton = app.buttons["By date"]
        _ = byDateButton.waitForExistence(timeout: 5)
        let subjectsButton = app.buttons["By subjects"]
        _ = subjectsButton.waitForExistence(timeout: 5)

        func testMoreModule() {
            moreButton.tap()
            let tableView = app.tables["tableView"]
            _ = tableView.waitForExistence(timeout: 5)
            XCTAssert(tableView.exists, "MoreModule tableViewGeneration failed")
            let tableViewCells = tableView.cells.element(boundBy: 0).staticTexts["cellLabel"]
            _ = tableViewCells.waitForExistence(timeout: 5)
            XCTAssert(tableViewCells.exists, "MoreModule cellGeneration failed")
            app.navigationBars["More"].buttons["Journal"].tap()
        }

        func testByDateModule() {
            byDateButton.tap()
            let defaultLabel = app.staticTexts["There were no lessons in specified date"]
            XCTAssert(defaultLabel.exists, "defaultLabel Doesn't Exist")
            let datePickersQuery = app.datePickers
            let leftPickerWheel = datePickersQuery.pickerWheels[currentMonth]
            XCTAssert(leftPickerWheel.exists, "leftPickerWheel is wrong")
            leftPickerWheel.swipeDown()
            XCTAssert(datePickersQuery.pickerWheels[swipeDownMonth].exists, "leftPickerWheel after swipedown is wrong")
//          TODO: write tableTest

            app.navigationBars["By date"].buttons["Journal"].tap()
            byDateButton.tap()
            XCTAssert(leftPickerWheel.exists, "leftPickerWheel after changing previous value is wrong")
        }
        testMoreModule()
        testByDateModule()
        app.terminate()
    }
}
