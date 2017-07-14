//
//  ArrayExt.swift
//  TestMK
//
//  Created by Dima Gubatenko on 14.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    mutating func removeDuplicates() {
        var array = [Element]()
        for item in self where !array.contains(item) {
            array.append(item)
        }
        self = array
    }
}
