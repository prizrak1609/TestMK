//
//  TestMKTests.swift
//  TestMKTests
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import XCTest
@testable import TestMK

class TestMKTests: XCTestCase {

    var database: Database?
    
    override func setUp() {
        super.setUp()
        database = Database()
        let _ = database?.openOrCreate()
    }
    
    override func tearDown() {
        if case .success(let cars) = database!.getAllCars() {
            for car in cars {
                let _ = database!.remove(car: car)
            }
        }
        if case .success(let drivers) = database!.getAllDrivers() {
            for driver in drivers {
                let _ = database!.remove(driver: driver)
            }
        }
        database!.close()
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(true)
    }

    func testCreateCar() {
        var car = CarsInfo()
        XCTAssertTrue(car.isEmpty)
        car.id = 1
        car.description = "b"
        car.name = "n"
        car.photoPath = "t"
        XCTAssertFalse(car.isEmpty)
        if case .error(let text) = database!.create(car: car) {
            XCTAssertTrue(false, text)
        }
    }

    func testCreateDriver() {
        var driver = DriverInfo()
        XCTAssertTrue(driver.isEmpty)
        driver.id = 1
        driver.name = "n"
        driver.photoPath = "p"
        XCTAssertFalse(driver.isEmpty)
        var firstCar = CarsInfo()
        firstCar.name = "n"
        var secondCar = CarsInfo()
        secondCar.name = "n1"
        if case .success(let first) = database!.create(car: firstCar), case .success(let second) = database!.create(car: secondCar) {
            firstCar = first
            secondCar = second
        }
        driver.cars = [firstCar, secondCar]
        if case .error(let text) = database!.create(driver: driver) {
            XCTAssertTrue(false, text)
        }
    }

    func testGetCars() {
        testCreateCar()
        var cars = [CarsInfo]()
        switch database!.getAllCars() {
            case .error(let text): XCTAssertFalse(true, text)
            case .success(let _cars): cars = _cars
        }
        XCTAssertTrue(cars.count > 0)
        let car = cars[0]
        XCTAssertFalse(car.isEmpty)
        XCTAssertTrue(car.name == "n")
        XCTAssertTrue(car.description == "b")
        XCTAssertTrue(car.photoPath == "t")
    }

    func testGetDrivers() {
        testCreateDriver()
        var drivers = [DriverInfo]()
        switch database!.getAllDrivers() {
            case .error(let text): XCTAssertFalse(true, text)
            case .success(let _drivers):
                print(_drivers)
                drivers = _drivers
        }
        XCTAssertTrue(drivers.count > 0)
        let driver = drivers[0]
        XCTAssertFalse(driver.isEmpty)
        XCTAssertTrue(driver.name == "n")
        XCTAssertTrue(driver.photoPath == "p")
        let cars = driver.cars
        print(cars)
        XCTAssertTrue(cars.count == 2)
        XCTAssertTrue(cars[0].name == "n")
        XCTAssertTrue(cars[1].name == "n1")
    }

    func testUpdateCar() {
        testCreateCar()
        var cars = [CarsInfo]()
        switch database!.getAllCars() {
            case .error(let text): XCTAssertFalse(true, text)
            case .success(let _cars): cars = _cars
        }
        XCTAssertTrue(cars.count > 0)
        var car = cars[0]
        XCTAssertFalse(car.isEmpty)
        XCTAssertTrue(car.name == "n")
        XCTAssertTrue(car.description == "b")
        XCTAssertTrue(car.photoPath == "t")
        car.name = "qwe"
        car.description = ""
        car.photoPath = "path"
        if case .error(let text) = database!.update(car: car) {
            XCTAssertTrue(false, text)
        }
        switch database!.getAllCars() {
            case .error(let text): XCTAssertFalse(true, text)
            case .success(let _cars): cars = _cars
        }
        XCTAssertTrue(cars.count > 0)
        car = cars[0]
        XCTAssertFalse(car.isEmpty)
        XCTAssertTrue(car.name == "qwe")
        XCTAssertTrue(car.description.isEmpty)
        XCTAssertTrue(car.photoPath == "path")
    }

    func testUpdateDriver() {
        testCreateDriver()
        var drivers = [DriverInfo]()
        switch database!.getAllDrivers() {
            case .error(let text): XCTAssertFalse(true, text)
            case .success(let _drivers): drivers = _drivers
        }
        XCTAssertTrue(drivers.count > 0)
        var driver = drivers[0]
        XCTAssertFalse(driver.isEmpty)
        XCTAssertTrue(driver.name == "n")
        XCTAssertTrue(driver.photoPath == "p")
        XCTAssertTrue(driver.cars.count == 2)
        XCTAssertTrue(driver.cars[0].name == "n")
        XCTAssertTrue(driver.cars[1].name == "n1")
        var car = CarsInfo()
        car.name = "n2"
        if case .success(let _car) = database!.create(car: car) {
            driver.cars.append(_car)
        }
        driver.name = "qwe"
        driver.photoPath = "path"
        if case .error(let text) = database!.update(driver: driver) {
            XCTAssertTrue(false, text)
        }
        switch database!.getAllDrivers() {
            case .error(let text): XCTAssertFalse(true, text)
            case .success(let _drivers): drivers = _drivers
        }
        XCTAssertTrue(drivers.count > 0)
        driver = drivers[0]
        XCTAssertFalse(driver.isEmpty)
        XCTAssertTrue(driver.name == "qwe")
        XCTAssertTrue(driver.photoPath == "path")
        XCTAssertTrue(driver.cars.count == 3)
        XCTAssertTrue(driver.cars[0].name == "n")
        XCTAssertTrue(driver.cars[1].name == "n1")
        XCTAssertTrue(driver.cars[2].name == "n2")
    }
}
