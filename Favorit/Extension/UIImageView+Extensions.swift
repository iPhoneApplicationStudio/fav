//
//  UIImageView+Extensions.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import UIKit

extension UIImage {
    static func getTemplateImage(imageName: String) -> UIImage? {
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        return tintedImage
    }
}
