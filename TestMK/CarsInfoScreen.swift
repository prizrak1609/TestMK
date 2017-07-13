//
//  CarsInfoScreen.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class CarsInfoScreen : UIViewController {

    @IBOutlet fileprivate weak var nameTextField: UITextField!
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var textDescriptionTextField: UITextView!

    var model: CarsInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Car info", comment: "CarsInfo screen")
        guard let model = model else { return }
        nameTextField.text = model.name
        textDescriptionTextField.text = model.description
        photoImageView.image = UIImage(contentsOfFile: model.photoPath)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: update info
    }
}
