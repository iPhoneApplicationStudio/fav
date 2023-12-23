//
//  SavedCell.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation
import UIKit

class SavedCell: UITableViewCell {
    @IBOutlet weak var primaryTipLabel: UILabel!
    @IBOutlet weak var favoritCountLabel: UILabel!
    @IBOutlet weak var savedCountLabel: UILabel!
    @IBOutlet weak var venueCategoryLabel: UILabel!
    @IBOutlet weak var venueTitleLabel: UILabel!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
    var place: Place? {
        didSet {
            guard let place else {
                return
            }
            
            self.setUpData(place: place)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookmarkImageView.image = UIImage.getTemplateImage(imageName: "bookmark1")
        bookmarkImageView.tintColor = .lightGray
    }
    
    override func prepareForReuse() {
        if !starImageView.isHidden {
            starImageView.isHidden = true
        }
        
        primaryTipLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        venueImageView.layer.cornerRadius = 5.0
        venueImageView.clipsToBounds = true
    }

    private func setUpData(place: Place) {
        self.venueTitleLabel.text = place.name
        self.venueCategoryLabel.text = place.categories?.first?.name ?? ""
        
        if let photoUrl = URL(string: place.categories?.first?.icon ?? "") {
            self.venueImageView.kf.setImage(with: photoUrl,
                                       options: [.transition(.fade(0.5)), .forceTransition])
        }
        
        
//        if let venueTip = savedVenue?.venueTip {
//            if venueTip.tip != StringConstants.TipStrings.defaultTip {
//                primaryTipLabel.text = venueTip.tip
//            }
//        }
    
        self.savedCountLabel.text = "\(place.bookmarkCount ?? 0)"
        self.favoritCountLabel.text = "\(place.favouriteCount ?? 0)"
    }
}
