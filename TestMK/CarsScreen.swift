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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = NSLocalizedString("Cars", comment: "CarsScreen title")
        let addCarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCarButtonClicked))
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonClicked))
        navigationItem.rightBarButtonItems = [addCarButton, editButton]
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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.carsInfo) as? CarsInfoCell else { return UITableViewCell() }
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .normal, title: "Edit", handler: { [weak self] _, indexPath in
            guard let welf = self else { return }
            print(indexPath)
            if let carInfoScreen = Storyboards.carsInfo {
                welf.navigationController?.pushViewController(carInfoScreen, animated: true)
            } else {
                showText("can't get \(Storyboards.Name.carsInfo) storyboard")
            }
        })]
    }
}

private extension CarsScreen {

    @objc
    func addCarButtonClicked() {
        if let carCreateScreen = Storyboards.carsCreate {
            navigationController?.pushViewController(carCreateScreen, animated: true)
        } else {
            showText("can't get \(Storyboards.Name.carsCreate) storyboard")
        }
    }

    @objc
    func editButtonClicked() {
        tableViewIsInEditMode = !tableViewIsInEditMode
        tableView.setEditing(tableViewIsInEditMode, animated: true)
    }
}
