//
//  CarsInfo.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

struct CarsInfo {
    var id = -1
    var photoPath = ""
    var name = ""
    var description = ""

    var isEmpty: Bool {
        return name.isEmpty && id == -1
    }
}
