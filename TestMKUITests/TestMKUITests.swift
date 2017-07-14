//
//  TestMKUITests.swift
//  TestMKUITests
//
//  Created by Dima Gubatenko on 14.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import XCTest

class TestMKUITests: XCTestCase {
        
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
        XCTAssertTrue(true)
    }

    func testOpenMainScreen() {
        let element = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.swipeDown()
        element.swipeUp()
        element.swipeDown()
        element.swipeUp()
        element.swipeDown()
        element.swipeUp()
        element.tap()
        element.tap()
    }

    func testOpenCarsScreen() {
        XCUIApplication().buttons["Work with cars"].tap()
    }

    func testOpenDriversScreen() {
        XCUIApplication().buttons["Work with drivers"].tap()
    }

    func testOpenCreateCarScreen() {
        let app = XCUIApplication()
        app.buttons["Work with cars"].tap()
        app.navigationBars["Cars"].buttons["Add"].tap()
    }

    func testOpenCreateDriverScreen() {
        let app = XCUIApplication()
        app.buttons["Work with drivers"].tap()
        app.navigationBars["Drivers"].buttons["Add"].tap()
    }

    func testCreateAndDeleteCar() {
        let app = XCUIApplication()
        app.buttons["Work with cars"].tap()
        app.navigationBars["Cars"].buttons["Add"].tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("test")
        app.otherElements.containing(.navigationBar, identifier:"TestMK.CarsCreateScreen").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["Create"].tap()
        let tablesQuery = app.tables
        let testStaticText = tablesQuery.staticTexts["test"]
        testStaticText.swipeLeft()
        tablesQuery.buttons["Delete"].swipeLeft()
    }

    func testCreateAndDeleteDriverWithoutCar() {
        let app = XCUIApplication()
        app.buttons["Work with drivers"].tap()
        app.navigationBars["Drivers"].buttons["Add"].tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("test")
        app.otherElements.containing(.navigationBar, identifier:"TestMK.DriverCreateScreen").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["Create"].tap()
        let tablesQuery = app.tables
        let testStaticText = tablesQuery.staticTexts["test"]
        testStaticText.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
    }

    func testCreateAndEditAndDeleteCar() {
        let app = XCUIApplication()
        app.buttons["Work with cars"].tap()
        app.navigationBars["Cars"].buttons["Add"].tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("test")
        let element = app.otherElements.containing(.navigationBar, identifier:"TestMK.CarsCreateScreen").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        app.buttons["Create"].tap()
        let tablesQuery = app.tables
        let testStaticText = tablesQuery.staticTexts["test"]
        testStaticText.swipeLeft()
        let editButton = tablesQuery.buttons["Edit"]
        editButton.tap()
        element.children(matching: .image).element.tap()
        app.sheets.buttons["Choose image"].tap()
        tablesQuery.buttons["Camera Roll"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, August 08, 2012, 9:52 PM"].tap()
        app.buttons["Update"].tap()
        testStaticText.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
    }

    func testCreateAndEditAndDeleteDriverWithoutCar() {
        let app = XCUIApplication()
        app.buttons["Work with drivers"].tap()
        app.navigationBars["Drivers"].buttons["Add"].tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("test")
        let element = app.otherElements.containing(.navigationBar, identifier:"TestMK.DriverCreateScreen").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        app.buttons["Create"].tap()
        let tablesQuery2 = app.tables
        let testStaticText = tablesQuery2.staticTexts["test"]
        testStaticText.swipeLeft()
        let tablesQuery = tablesQuery2
        tablesQuery.buttons["Edit"].tap()
        element.children(matching: .image).element.tap()
        app.sheets.buttons["Choose image"].tap()
        tablesQuery.buttons["Camera Roll"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Portrait, August 09, 2012, 12:29 AM"].tap()
        app.buttons["Update"].tap()
        testStaticText.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
    }

    func testCreateAndEditAndDeleteDriverWithCar() {
        let app = XCUIApplication()
        app.buttons["Work with cars"].tap()
        let carsNavigationBar = app.navigationBars["Cars"]
        carsNavigationBar.buttons["Add"].tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("test")
        app.otherElements.containing(.navigationBar, identifier:"TestMK.CarsCreateScreen").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .image).element.tap()
        app.sheets.buttons["Choose image"].tap()
        let tablesQuery = app.tables
        tablesQuery.buttons["Camera Roll"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, August 08, 2012, 9:52 PM"].tap()
        let createButton = app.buttons["Create"]
        createButton.tap()
        app.navigationBars["Cars"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        app.buttons["Work with drivers"].tap()
        app.navigationBars["Drivers"].buttons["Add"].tap()
        nameTextField.tap()
        nameTextField.typeText("test")
        app.buttons["Add car"].tap()
        let testStaticText = tablesQuery.staticTexts["test"]
        testStaticText.tap()
        app.navigationBars["TestMK.CarsChoose"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        createButton.tap()
        testStaticText.swipeLeft()
        tablesQuery.buttons["Edit"].swipeLeft()
        testStaticText.swipeLeft()
        let deleteButton = tablesQuery.buttons["Delete"]
        deleteButton.tap()
        app.buttons["Update"].tap()
        testStaticText.swipeLeft()
        tablesQuery.buttons["Edit"].tap()
        app.navigationBars["TestMK.DriverCreateScreen"].buttons["Drivers"].tap()
        testStaticText.swipeLeft()
        deleteButton.swipeLeft()
        app.navigationBars["Drivers"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        app.buttons["Work with cars"].tap()
        testStaticText.swipeLeft()
        deleteButton.tap()
    }
}
