//
//  DriverInfo.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

struct DriverInfo {
    var photoPath = ""
    var name = ""
    var cars = [CarsInfo]()

    var isEmpty: Bool {
        return name.isEmpty
    }
}
