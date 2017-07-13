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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoImageView.layer.borderColor = UIColor.blue.cgColor
        photoImageView.layer.borderWidth = 1
        if !model.isEmpty {
            createButton.isHidden = true
            photoImageView.image = UIImage(contentsOfFile: model.photoPath)
            nameTextField.text = model.name
            // TODO: update cars
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if createButton.isHidden {
            // TODO: update driver info
        }
    }

    @IBAction func addCar(_ sender: UIButton) {
        // TODO: show CarsChoose
    }

    @IBAction func createDriver(_ sender: UIButton) {
        // TODO: create driver
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
            welf.model.cars.remove(at: indexPath.row)
        })]
    }
}
