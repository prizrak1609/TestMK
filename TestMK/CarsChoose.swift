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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let choosedCars = selectedIndexes.map { models[$0] }
        delegate?.CCPchoosed(cars: choosedCars)
    }
}

extension CarsChoose : UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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
        if selectedIndexes.contains(indexPath.row) {
            cell.setSelected(true, animated: true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexes.append(indexPath.row)
    }
}
