//
//  FoodImageViewCell.swift
//  Project1
//
//  Created by anca dev on 10/12/23.
//

import UIKit

class FoodImageViewCell: UICollectionViewCell {
    @IBOutlet weak var imagePlace: UIImageView!
    
    var imgUrl: String? {
        didSet {
            guard let imgUrl = imgUrl,
                  let url = URL(string: imgUrl) else {
                self.imagePlace.image = nil
                return
            }
            
            self.imagePlace.kf.setImage(with: url,
                                       options: [.transition(.fade(0.5)), .forceTransition])
        }
    }
}
