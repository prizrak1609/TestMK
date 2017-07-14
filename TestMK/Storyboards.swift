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

    static var main: UIViewController? {
        return UIStoryboard(name: Name.main, bundle: nil).instantiateInitialViewController()
    }
    static var carsCreate: UIViewController? {
        return UIStoryboard(name: Name.carsCreate, bundle: nil).instantiateInitialViewController()
    }
    static var driverCreate: UIViewController? {
        return UIStoryboard(name: Name.driverCreate, bundle: nil).instantiateInitialViewController()
    }
}
