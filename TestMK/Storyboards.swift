//
//  Storyboards.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

enum Storyboards {

    enum Name {
        static let main = "Main"
        static let carsInfo = "CarsInfoScreen"
        static let carsCreate = "CarsCreateScreen"
        static let driverCreate = "DriverCreateScreen"
        static let driverInfo = "DriverInfoScreen"
    }

    static let main = UIStoryboard(name: Name.main, bundle: nil).instantiateInitialViewController()
    static let carsInfo = UIStoryboard(name: Name.carsInfo, bundle: nil).instantiateInitialViewController()
    static let carsCreate = UIStoryboard(name: Name.carsCreate, bundle: nil).instantiateInitialViewController()
    static let driverCreate = UIStoryboard(name: Name.driverCreate, bundle: nil).instantiateInitialViewController()
    static let driverInfo = UIStoryboard(name: Name.driverInfo, bundle: nil).instantiateInitialViewController()
}
