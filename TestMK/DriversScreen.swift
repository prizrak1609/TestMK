//
//  DriversScreen.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class DriversScreen: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!

    fileprivate var tableViewIsInEditMode = false
    fileprivate var drivers = [DriverInfo]()
    fileprivate let database = Database()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = NSLocalizedString("Drivers", comment: "DriversScreen title")
        let addCarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDriverButtonClicked))
        navigationItem.rightBarButtonItems = [addCarButton]
        initTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if case .error(let text) = database.openOrCreate() {
            log(text)
        }
        switch database.getAllDrivers() {
            case .error(let text): log(text)
            case .success(let drivers):
                self.drivers = drivers
                tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        database.close()
    }
}

extension DriversScreen : UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: Cell.driverInfo, bundle: nil), forCellReuseIdentifier: Cell.driverInfo)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.driverInfo) as? DriverInfoCell else { return UITableViewCell() }
        cell.model = drivers[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { [weak self] _, indexPath in
            guard let welf = self else { return }
            if let driverCreateScreen = Storyboards.driverCreate as? DriverCreateScreen {
                driverCreateScreen.model = welf.drivers[indexPath.row]
                welf.navigationController?.pushViewController(driverCreateScreen, animated: true)
            } else {
                showText("can't get \(Storyboards.Name.driverCreate) storyboard")
            }
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { [weak self] _, indexPath in
            guard let welf = self else { return }
            let driver = welf.drivers.remove(at: indexPath.row)
            if case .error(let text) = welf.database.remove(driver: driver) {
                log(text)
            }
        }
        return [deleteAction, editAction]
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
