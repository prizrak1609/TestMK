//
//  CarsChoose.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

protocol CarsChooseProtocol : class {
    func CCPchoosed(cars: [CarsInfo])
}

final class CarsChoose : UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!

    weak var delegate: CarsChooseProtocol?

    fileprivate var models = [CarsInfo]()
    fileprivate var selectedIndexes = [Int]()
    fileprivate let database = Database()

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        if case .error(let text) = database.openOrCreate() {
            log(text)
        }
        switch database.getAllCars() {
            case .error(let text): log(text)
            case .success(let cars):
                models = cars
                tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let choosedCars = selectedIndexes.map { models[$0] }
        delegate?.CCPchoosed(cars: choosedCars)
        database.close()
    }
}

extension CarsChoose : UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 112
        tableView.register(UINib(nibName: Cell.carsInfo, bundle: nil), forCellReuseIdentifier: Cell.carsInfo)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.carsInfo) as? CarsInfoCell else { return UITableViewCell() }
        cell.model = models[indexPath.row]
        cell.setSelected(selectedIndexes.contains(indexPath.row), animated: true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexes.append(indexPath.row)
    }
}
