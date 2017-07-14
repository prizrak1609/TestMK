//
//  DriverCreateScreen.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import IQKeyboardManager

final class DriverCreateScreen : UIViewController {

    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var createButton: UIButton!

    var model = DriverInfo()

    fileprivate let imagePicker = UIImagePickerController()
    fileprivate let database = Database()
    fileprivate var isInEditState = false {
        didSet {
            if isInEditState {
                createButton.setTitle(NSLocalizedString("Update", comment: "update button DriverCreateScreen"), for: .normal)
            } else {
                createButton.setTitle(NSLocalizedString("Create", comment: "create button DriverCreateScreen"), for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if case .error(let text) = database.openOrCreate() {
            log(text)
        }
        photoImageView.layer.borderColor = UIColor.blue.cgColor
        photoImageView.layer.borderWidth = 1
        if !model.isEmpty {
            isInEditState = true
            photoImageView.setImage(path: model.photoPath)
            nameTextField.text = model.name
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        database.close()
    }

    @IBAction func addCar(_ sender: UIButton) {
        if let carsChooseStoryboard = UIStoryboard(name: "CarsChoose", bundle: nil).instantiateInitialViewController() as? CarsChoose {
            carsChooseStoryboard.delegate = self
            navigationController?.pushViewController(carsChooseStoryboard, animated: true)
        } else {
            log("can't get CarsChoose storyboard")
        }
    }

    @IBAction func createDriver(_ sender: UIButton) {
        let name = nameTextField.text ?? ""
        if name.isEmpty {
            showText(NSLocalizedString("fill name", comment: "DriverCreateScreen"))
            return
        }
        model.name = name
        if isInEditState {
            if case .error(let text) = database.update(driver: model) {
                showText(NSLocalizedString("somesing wrong when update info", comment: "Driver create screen"))
                log(text)
            } else {
                navigationController?.popViewController(animated: true)
            }
        } else {
            if case .error(let text) = database.create(driver: model) {
                showText(NSLocalizedString("somesing wrong when create driver", comment: "Driver create screen"))
                log(text)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let chooseImageAction = UIAlertAction(title: NSLocalizedString("Choose image", comment: "choose image in DriverCreateScreen"), style: .default) { [weak self] _ in
            guard let welf = self else { return }
            welf.imagePicker.sourceType = .photoLibrary
            welf.imagePicker.delegate = welf
            alert.dismiss(animated: true, completion: nil)
            welf.present(welf.imagePicker, animated: true, completion: nil)
        }
        let closeAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel in DriverCreateScreen"), style: .cancel, handler: nil)
        alert.addAction(chooseImageAction)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func closeKeyboard(_ sender: UITapGestureRecognizer) {
        IQKeyboardManager.shared().resignFirstResponder()
    }
}

extension DriverCreateScreen : CarsChooseProtocol {

    func CCPchoosed(cars: [CarsInfo]) {
        model.cars.append(contentsOf: cars)
        model.cars.removeDuplicates()
        tableView.reloadData()
    }
}

extension DriverCreateScreen : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoImageView.layer.borderWidth = 0
        model.photoPath = (info[UIImagePickerControllerReferenceURL] as? URL)?.absoluteString ?? ""
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension DriverCreateScreen : UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 112
        tableView.register(UINib(nibName: Cell.carsInfo, bundle: nil), forCellReuseIdentifier: Cell.carsInfo)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.carsInfo) as? CarsInfoCell else { return UITableViewCell() }
        cell.model = model.cars[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .normal, title: "Delete", handler: { [weak self] _, indexPath in
            guard let welf = self else { return }
            let car = welf.model.cars.remove(at: indexPath.row)
            if case .error(let text) = welf.database.removeRelationShip(driver: welf.model, car: car) {
                showText(NSLocalizedString("somesing wrong when remove car", comment: "DriverCreateScreen"))
                log(text)
            }
            welf.tableView.reloadData()
        })]
    }
}
