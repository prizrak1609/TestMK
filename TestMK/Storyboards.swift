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
        static let carsCreate = "CarsCreateScreen"
        static let driverCreate = "DriverCreateScreen"
    }

    static let main = UIStoryboard(name: Name.main, bundle: nil).instantiateInitialViewController()
    static let carsCreate = UIStoryboard(name: Name.carsCreate, bundle: nil).instantiateInitialViewController()
    static let driverCreate = UIStoryboard(name: Name.driverCreate, bundle: nil).instantiateInitialViewController()
}
