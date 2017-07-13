//
//  CarsInfoScreen.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class CarsInfoScreen : UIViewController {

    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!

    var model: CarsInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Car info", comment: "CarsInfo screen")
        guard let model = model else { return }
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        photoImageView.image = UIImage(contentsOfFile: model.photoPath)
    }
}
