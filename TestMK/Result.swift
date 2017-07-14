//
//  Result.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

enum Result<T: Any> {
    case error(String)
    case success(T)
}
