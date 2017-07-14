//
//  CarsScreen.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class CarsScreen : UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!

    fileprivate var tableViewIsInEditMode = false
    fileprivate let database = Database()
    fileprivate var cars = [CarsInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = NSLocalizedString("Cars", comment: "CarsScreen title")
        let addCarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCarButtonClicked))
        navigationItem.rightBarButtonItems = [addCarButton]
        initTableView()
        if case .error(let text) = database.openOrCreate() {
            log(text)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch database.getAllCars() {
            case .error(let text): log(text)
            case .success(let cars):
                self.cars = cars
                tableView.reloadData()
        }
    }
}

extension CarsScreen : UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.carsInfo, bundle: nil), forCellReuseIdentifier: Cell.carsInfo)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.carsInfo) as? CarsInfoCell else { return UITableViewCell() }
        cell.model = cars[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { [weak self] _, indexPath in
            guard let welf = self else { return }
            if let carCreateScreen = Storyboards.carsCreate as? CarsCreateScreen {
                carCreateScreen.model = welf.cars[indexPath.row]
                welf.navigationController?.pushViewController(carCreateScreen, animated: true)
            } else {
                log("can't get \(Storyboards.Name.carsCreate) storyboard")
            }
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { [weak self] _, indexPath in
            guard let welf = self else { return }
            let car = welf.cars.remove(at: indexPath.row)
            if case .error(let text) = welf.database.remove(car: car) {
                log(text)
            }
            welf.tableView.reloadData()
        }
        return [editAction, deleteAction]
    }
}

private extension CarsScreen {

    @objc
    func addCarButtonClicked() {
        if let carCreateScreen = Storyboards.carsCreate {
            navigationController?.pushViewController(carCreateScreen, animated: true)
        } else {
            log("can't get \(Storyboards.Name.carsCreate) storyboard")
        }
    }

    @objc
    func editButtonClicked() {
        tableViewIsInEditMode = !tableViewIsInEditMode
        tableView.setEditing(tableViewIsInEditMode, animated: true)
    }
}
