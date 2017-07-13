//
//  ViewController.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet fileprivate weak var workWithDriversButton: UIButton!
    @IBOutlet fileprivate weak var workWithCarsButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        workWithDriversButton.layer.cornerRadius = 10
        workWithDriversButton.layer.borderColor = UIColor.blue.cgColor
        workWithDriversButton.layer.borderWidth = 1
        workWithCarsButton.layer.cornerRadius = 10
        workWithCarsButton.layer.borderWidth = 1
        workWithCarsButton.layer.borderColor = UIColor.blue.cgColor
    }
}
