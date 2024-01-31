//
//  UIView+Border.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation
import UIKit

public struct BorderProperties {
    let color: UIColor
    let width: CGFloat
    let cornerRadius: CGFloat

    public init(
        color: UIColor,
        width: CGFloat,
        cornerRadius: CGFloat) {
        self.color = color
        self.width = width
        self.cornerRadius = cornerRadius
    }

    public init(
        color: UIColor,
        width: CGFloat) {
        self.init(color: color, width: width, cornerRadius: 0)
    }
}

extension UIView {

    public func apply(border: BorderProperties?) {

        guard let border = border else {
            layer.borderColor = nil
            layer.borderWidth = 0
            layer.cornerRadius = 0
            return
        }

        layer.borderColor = border.color.cgColor
        layer.borderWidth = border.width
        layer.cornerRadius = border.cornerRadius
    }
}
