//
//  CarsInfoCell.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class CarsInfoCell: UITableViewCell {
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!

    var model: CarsInfo? {
        didSet {
            guard let model = model else { return }
            photoImageView.image = UIImage(contentsOfFile: model.photoPath)
            nameLabel.text = model.name
            descriptionLabel.text = model.description
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
