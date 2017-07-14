//
//  Database.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation

final class Database {

    fileprivate let dbPath: String
    fileprivate var database: OpaquePointer?

    init() {
        if var documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            documents.appendPathComponent("testmk.db")
            dbPath = documents.absoluteString
        } else {
            dbPath = ""
        }
    }

    func openOrCreate() -> Result<Void> {
        if sqlite3_open(dbPath, &database) != SQLITE_OK {
            return .error("Unable to open database, check path: \(dbPath)")
        } else {
            var createTable: OpaquePointer?
            let createDriversString = "create table if not exists drivers ( id integer PRIMARY KEY AUTOINCREMENT NOT NULL, photoPath text NOT NULL, name text NOT NULL );"
            let createCarsString = "create table if not exists cars ( id integer PRIMARY KEY AUTOINCREMENT NOT NULL, photoPath text NOT NULL, name text NOT NULL, description text NOT NULL );"
            let createDriversCarsString = "create table if not exists drivers_cars ( driverId integer REFERENCES drivers (id) ON DELETE RESTRICT ON UPDATE RESTRICT NOT NULL, carId integer REFERENCES cars (id) ON DELETE RESTRICT ON UPDATE RESTRICT NOT NULL, PRIMARY KEY ( driverId, carId ) );"
            if sqlite3_prepare_v2(database, createDriversString, -1, &createTable, nil) == SQLITE_OK {
                if sqlite3_step(createTable) != SQLITE_DONE {
                    return .error("\(String(cString: sqlite3_errmsg(database)))")
                }
            } else {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
            sqlite3_finalize(createTable)
            if sqlite3_prepare_v2(database, createCarsString, -1, &createTable, nil) == SQLITE_OK {
                if sqlite3_step(createTable) != SQLITE_DONE {
                    return .error("\(String(cString: sqlite3_errmsg(database)))")
                }
            } else {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
            sqlite3_finalize(createTable)
            if sqlite3_prepare_v2(database, createDriversCarsString, -1, &createTable, nil) == SQLITE_OK {
                if sqlite3_step(createTable) != SQLITE_DONE {
                    return .error("\(String(cString: sqlite3_errmsg(database)))")
                }
            } else {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
            sqlite3_finalize(createTable)
            return .success()
        }
    }

    func close() {
        sqlite3_close(database)
    }

    deinit {
        close()
    }

    func create(car: CarsInfo) -> Result<CarsInfo> {
        var createItem: OpaquePointer?
        let createCarString = "insert into cars (photoPath, name, description) values (?, ?, ?);"
        if sqlite3_prepare_v2(database, createCarString, -1, &createItem, nil) == SQLITE_OK {
            sqlite3_bind_text(createItem, 1, (car.photoPath as NSString).utf8String, -1, nil)
            sqlite3_bind_text(createItem, 2, (car.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(createItem, 3, (car.description as NSString).utf8String, -1, nil)
            if sqlite3_step(createItem) != SQLITE_DONE {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(createItem)
        // get last created id
        let driverId = sqlite3_last_insert_rowid(database)
        var car = car
        car.id = driverId
        return .success(car)
    }

    func create(driver: DriverInfo) -> Result<DriverInfo> {
        var createItem: OpaquePointer?
        let createDriverString = "insert into drivers (photoPath, name) values (?, ?);"
        if sqlite3_prepare_v2(database, createDriverString, -1, &createItem, nil) == SQLITE_OK {
            sqlite3_bind_text(createItem, 1, (driver.photoPath as NSString).utf8String, -1, nil)
            sqlite3_bind_text(createItem, 2, (driver.name as NSString).utf8String, -1, nil)
            if sqlite3_step(createItem) != SQLITE_DONE {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(createItem)
        var driver = driver
        // get last created id
        let driverId = sqlite3_last_insert_rowid(database)
        driver.id = driverId
        for car in driver.cars {
            if case .error(let text) = createRelationShip(driver: driver, car: car) {
                return .error(text)
            }
        }
        return .success(driver)
    }

    fileprivate func createRelationShip(driver: DriverInfo, car: CarsInfo) -> Result<Void> {
        var createItem: OpaquePointer?
        let createDriverString = "insert into drivers_cars (driverId, carId) values (?, ?);"
        if sqlite3_prepare_v2(database, createDriverString, -1, &createItem, nil) == SQLITE_OK {
            sqlite3_bind_int64(createItem, 1, driver.id)
            sqlite3_bind_int64(createItem, 2, car.id)
            if sqlite3_step(createItem) != SQLITE_DONE {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(createItem)
        return .success()
    }

    func update(car: CarsInfo) -> Result<Void> {
        var updateItem: OpaquePointer?
        let updateCarString = "UPDATE cars SET photoPath = ?, name = ?, description = ? WHERE id = ?;"
        if sqlite3_prepare_v2(database, updateCarString, -1, &updateItem, nil) == SQLITE_OK {
            sqlite3_bind_text(updateItem, 1, (car.photoPath as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateItem, 2, (car.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateItem, 3, (car.description as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(updateItem, 4, car.id)
            if sqlite3_step(updateItem) != SQLITE_DONE {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(updateItem)
        return .success()
    }

    func update(driver: DriverInfo) -> Result<Void> {
        var updateItem: OpaquePointer?
        let updateDriverString = "update drivers set photoPath = ?, name = ? where id = ?;"
        if sqlite3_prepare_v2(database, updateDriverString, -1, &updateItem, nil) == SQLITE_OK {
            sqlite3_bind_text(updateItem, 1, (driver.photoPath as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateItem, 2, (driver.name as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(updateItem, 3, driver.id)
            if sqlite3_step(updateItem) != SQLITE_DONE {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(updateItem)
        return .success()
    }

    func remove(car: CarsInfo) -> Result<Void> {
        var removeItem: OpaquePointer?
        let removeCarString = "delete from cars where id = ?;"
        if sqlite3_prepare_v2(database, removeCarString, -1, &removeItem, nil) == SQLITE_OK {
            sqlite3_bind_int64(removeItem, 1, car.id)
            if sqlite3_step(removeItem) != SQLITE_DONE {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(removeItem)
        return removeRelationShip(driver: nil, car: car)
    }

    func remove(driver: DriverInfo) -> Result<Void> {
        var removeItem: OpaquePointer?
        let removeDriverString = "delete from cars where id = ?;"
        if sqlite3_prepare_v2(database, removeDriverString, -1, &removeItem, nil) == SQLITE_OK {
            sqlite3_bind_int64(removeItem, 1, driver.id)
            if sqlite3_step(removeItem) != SQLITE_DONE {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(removeItem)
        return removeRelationShip(driver: driver, car: nil)
    }

    func removeRelationShip(driver: DriverInfo?, car: CarsInfo?) -> Result<Void> {
        precondition(driver != nil || car != nil, "driver or car must != nil")
        var removeItem: OpaquePointer?
        var removeRelationshipString = "delete from drivers_cars where "
        let driverPartString = driver == nil ? "" : "driverId = ?"
        let carPartString = car == nil ? "" : "carId = ?"
        let space = !driverPartString.isEmpty && !carPartString.isEmpty ? ", " : ""
        removeRelationshipString.append(driverPartString)
        removeRelationshipString.append(space)
        removeRelationshipString.append(carPartString)
        removeRelationshipString.append(";")
        if sqlite3_prepare_v2(database, removeRelationshipString, -1, &removeItem, nil) == SQLITE_OK {
            if let driver = driver {
                sqlite3_bind_int64(removeItem, 1, driver.id)
            }
            if let car = car {
                let carIndex: Int32 = driver == nil ? 1 : 2
                sqlite3_bind_int64(removeItem, carIndex, car.id)
            }
            if sqlite3_step(removeItem) != SQLITE_DONE {
                return .error("\(String(cString: sqlite3_errmsg(database)))")
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(removeItem)
        return .success()
    }

    func getDriverCars(_ driver: DriverInfo) -> Result<[CarsInfo]> {
        var searchItem: OpaquePointer?
        let searchCarsIdString = "select carId from drivers_cars where driverId = ?;"
        var result = [CarsInfo]()
        // get car ids who in relationship with driver
        if sqlite3_prepare_v2(database, searchCarsIdString, -1, &searchItem, nil) == SQLITE_OK {
            sqlite3_bind_int64(searchItem, 1, driver.id)
            while sqlite3_step(searchItem) == SQLITE_ROW {
                let id = sqlite3_column_int64(searchItem, 0)
                var carSearchItem: OpaquePointer?
                let searchCarString = "select photoPath, name, description from cars where id = ?"
                // get car from selected id
                if sqlite3_prepare_v2(database, searchCarString, -1, &carSearchItem, nil) == SQLITE_OK {
                    sqlite3_bind_int64(carSearchItem, 1, id)
                    if sqlite3_step(searchItem) == SQLITE_ROW {
                        var car = CarsInfo()
                        car.id = id
                        car.photoPath = String(cString: sqlite3_column_text(carSearchItem, 0))
                        car.name = String(cString: sqlite3_column_text(carSearchItem, 1))
                        car.description = String(cString: sqlite3_column_text(carSearchItem, 2))
                        result.append(car)
                    }
                } else {
                    return .error("\(String(cString: sqlite3_errmsg(database)))")
                }
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(searchItem)
        return .success(result)
    }

//    func getDriver(id: Int) -> DriverInfo {
//        return DriverInfo()
//    }

    func getAllCars() -> Result<[CarsInfo]> {
        var searchItem: OpaquePointer?
        let searchCarsString = "select * from cars;"
        var result = [CarsInfo]()
        if sqlite3_prepare_v2(database, searchCarsString, -1, &searchItem, nil) == SQLITE_OK {
            while sqlite3_step(searchItem) == SQLITE_ROW {
                var car = CarsInfo()
                car.id = sqlite3_column_int64(searchItem, 0)
                car.photoPath = String(cString: sqlite3_column_text(searchItem, 1))
                car.name = String(cString: sqlite3_column_text(searchItem, 2))
                car.description = String(cString: sqlite3_column_text(searchItem, 3))
                result.append(car)
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(searchItem)
        return .success(result)
    }

    func getAllDrivers() -> Result<[DriverInfo]> {
        var searchItem: OpaquePointer?
        let searchDriversString = "select * from drivers;"
        var result = [DriverInfo]()
        if sqlite3_prepare_v2(database, searchDriversString, -1, &searchItem, nil) == SQLITE_OK {
            while sqlite3_step(searchItem) == SQLITE_ROW {
                var driver = DriverInfo()
                driver.id = sqlite3_column_int64(searchItem, 0)
                driver.photoPath = String(cString: sqlite3_column_text(searchItem, 1))
                driver.name = String(cString: sqlite3_column_text(searchItem, 2))
                switch getDriverCars(driver) {
                    case .error(let text): return .error(text)
                    case .success(let cars): driver.cars = cars
                }
                result.append(driver)
            }
        } else {
            return .error("\(String(cString: sqlite3_errmsg(database)))")
        }
        sqlite3_finalize(searchItem)
        return .success(result)
    }
}
