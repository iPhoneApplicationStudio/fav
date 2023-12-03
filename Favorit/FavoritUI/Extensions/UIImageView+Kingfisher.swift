//
//  UIImageView+Kingfisher.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    struct PlaceholderOptions {
        let text: String?
        let fontSize: CGFloat
        let backgroundColor: UIColor
        let isCircular: Bool
        let fontWeight: UIFont.Weight
        let textColor: UIColor
        
        init(
            text: String?,
            fontSize: CGFloat = 40,
            backgroundColor: UIColor = .lightGray,
            isCircular: Bool = true,
            fontWeight: UIFont.Weight = .light,
            textColor: UIColor = .white) {
                self.text = text
                self.fontSize = fontSize
                self.backgroundColor = backgroundColor
                self.isCircular = isCircular
                self.fontWeight = fontWeight
                self.textColor = textColor
            }
    }
    
    func setImage(from urlString: String?, placeholder options: PlaceholderOptions) {
        if let urlString, !urlString.isEmpty,
           let userPhotoUrl = URL(string: urlString) {
            kf.setImage(
                with: userPhotoUrl,
                options: [.transition(.fade(0.5)), .forceTransition]) { [weak self] result in
                    switch result {
                    case .success: break
                    case .failure:
                        self?.setImage(
                            string: options.text,
                            color: options.backgroundColor,
                            circular: options.isCircular,
                            textAttributes: [
                                .font: UIFont.systemFont(ofSize: options.fontSize, weight: options.fontWeight),
                                .foregroundColor: options.textColor]
                        )
                    }
                }
        } else {
            setImage(
                string: options.text,
                color: options.backgroundColor,
                circular: options.isCircular,
                textAttributes: [
                    .font: UIFont.systemFont(ofSize: options.fontSize, weight: options.fontWeight),
                    .foregroundColor: options.textColor]
            )
        }
    }
}
