//
//  CarsInfoScreen.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import IQKeyboardManager

final class CarsInfoScreen : UIViewController {

    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var textDescriptionTextField: UITextView!

    var model: CarsInfo?

    fileprivate let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Car info", comment: "CarsInfo screen")
        guard let model = model else { return }
        nameTextField.text = model.name
        textDescriptionTextField.text = model.description
        photoImageView.image = UIImage(contentsOfFile: model.photoPath)
        textDescriptionTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoImageView.layer.borderColor = UIColor.blue.cgColor
        photoImageView.layer.borderWidth = 1
        textDescriptionTextField.layer.cornerRadius = 10
        textDescriptionTextField.layer.borderWidth = 0.7
        textDescriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let chooseImageAction = UIAlertAction(title: NSLocalizedString("Choose image", comment: "choose image in CarsInfoScreen"), style: .default) { [weak self] _ in
            guard let welf = self else { return }
            welf.imagePicker.sourceType = .photoLibrary
            welf.imagePicker.delegate = welf
            alert.dismiss(animated: true, completion: nil)
            welf.present(welf.imagePicker, animated: true, completion: nil)
        }
        let closeAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel in CarsInfoScreen"), style: .cancel, handler: nil)
        alert.addAction(chooseImageAction)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func closeKeyboard(_ sender: UITapGestureRecognizer) {
        IQKeyboardManager.shared().resignFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: update info
    }
}

extension CarsInfoScreen : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoImageView.layer.borderWidth = 0
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension CarsInfoScreen : UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 255 {
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.red.cgColor
        } else {
            textView.layer.borderWidth = 0
        }
    }
}
