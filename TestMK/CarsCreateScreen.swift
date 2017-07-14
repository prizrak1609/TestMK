//
//  CarsCreateScreen.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import IQKeyboardManager

final class CarsCreateScreen : UIViewController {

    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionTextField: UITextView!
    @IBOutlet fileprivate weak var createButton: UIButton!

    var model = CarsInfo()

    fileprivate let imagePicker = UIImagePickerController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoImageView.layer.borderColor = UIColor.blue.cgColor
        photoImageView.layer.borderWidth = 1
        descriptionTextField.layer.cornerRadius = 10
        descriptionTextField.layer.borderWidth = 0.7
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        if !model.isEmpty {
            nameTextField.text = model.name
            photoImageView.image = UIImage(contentsOfFile: model.photoPath)
            descriptionTextField.text = model.description
            createButton.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if createButton.isHidden {
            // TODO: update info
        }
    }

    @IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let chooseImageAction = UIAlertAction(title: NSLocalizedString("Choose image", comment: "choose image in CarsCreateScreen"), style: .default) { [weak self] _ in
            guard let welf = self else { return }
            welf.imagePicker.sourceType = .photoLibrary
            welf.imagePicker.delegate = welf
            alert.dismiss(animated: true, completion: nil)
            welf.present(welf.imagePicker, animated: true, completion: nil)
        }
        let closeAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel in CarsCreateScreen"), style: .cancel, handler: nil)
        alert.addAction(chooseImageAction)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func closeKeyboard(_ sender: UITapGestureRecognizer) {
        IQKeyboardManager.shared().resignFirstResponder()
    }

    @IBAction func createCar(_ sender: UIButton) {
        // TODO: create car
    }
}

extension CarsCreateScreen : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoImageView.layer.borderWidth = 0
        model.photoPath = (info[UIImagePickerControllerReferenceURL] as? URL)?.absoluteString ?? ""
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
