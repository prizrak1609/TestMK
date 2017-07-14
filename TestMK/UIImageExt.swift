//
//  UIImageExt.swift
//  TestMK
//
//  Created by Dima Gubatenko on 14.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import Photos

extension UIImageView {

    func setImage(path: String) {
        if let url = URL(string: path),
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject {

            PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { [weak self] (data, _, _, _) in
                guard let welf = self, let data = data else { return }
                welf.image = UIImage(data: data)
            })
        }
    }
}
