//
//  DriversScreen.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class DriversScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var tableViewIsInEditMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = NSLocalizedString("Drivers", comment: "DriversScreen title")
        let addCarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDriverButtonClicked))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonClicked))
        navigationItem.rightBarButtonItems = [addCarButton, editButton]
        initTableView()
    }
}

extension DriversScreen : UITabBarDelegate, UITableViewDataSource {

    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.driverInfo, bundle: nil), forCellReuseIdentifier: Cell.driverInfo)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.driverInfo) as? DriverInfoCell else { return UITableViewCell() }
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .normal, title: "Edit", handler: { [weak self] _, indexPath in
            guard let welf = self else { return }
            print(indexPath)
            if let driverInfoScreen = Storyboards.driverInfo {
                welf.navigationController?.pushViewController(driverInfoScreen, animated: true)
            } else {
                showText("can't get \(Storyboards.Name.driverInfo) storyboard")
            }
        })]
    }
}

private extension DriversScreen {

    @objc
    func addDriverButtonClicked() {
        if let driverCreate = Storyboards.driverCreate {
            navigationController?.pushViewController(driverCreate, animated: true)
        } else {
            showText("can't get \(Storyboards.Name.driverCreate) storyboard")
        }
    }

    @objc
    func editButtonClicked() {
        tableViewIsInEditMode = !tableViewIsInEditMode
        tableView.setEditing(tableViewIsInEditMode, animated: true)
    }
}
