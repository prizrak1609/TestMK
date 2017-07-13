//
//  DriverInfoCell.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class DriverInfoCell: UITableViewCell {
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var name: UILabel!

    var model: DriverInfo? {
        didSet {
            guard let model = model else { return }
            photoImageView.image = UIImage(contentsOfFile: model.photoPath)
            name.text = model.name
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
