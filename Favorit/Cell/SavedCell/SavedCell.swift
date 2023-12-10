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
    
    var savedVenue: String? {
        didSet {
            setUpSavedVenueData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookmarkImageView.image = UIImage.getTemplateImage(imageName: "bookmark1")
        bookmarkImageView.tintColor = UIColor.lightGray
     
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

    func setUpSavedVenueData() {
        var photoStr = ""
//        if let photo = savedVenue?.favoritVenue?.featuredPhoto {
//            photoStr = photo
//        } else if let iconPhoto = savedVenue?.favoritVenue?.categoryIcon {
//            photoStr = iconPhoto
//        }
        
        let photoUrl = URL(string: photoStr)
        venueImageView.kf.setImage(with: photoUrl, options: [.transition(.fade(0.5)), .forceTransition])
        
//        if let venueTip = savedVenue?.venueTip {
//            if venueTip.tip != StringConstants.TipStrings.defaultTip {
//                primaryTipLabel.text = venueTip.tip
//            }
//        }
        
//        venueTitleLabel.text = savedVenue?.favoritVenue?.name
//        venueCategoryLabel.text = savedVenue?.favoritVenue?.primaryCategory
        var savedStr = ""
//        if let saved = savedVenue?.favoritVenue?.bookmarks?.intValue {
//            savedStr = "\(saved)"
//        }
        savedCountLabel.text = "\(savedStr)"

        var favoritStr = ""
//        if let favorit = savedVenue?.favoritVenue?.favorits?.intValue {
//            favoritStr = "\(favorit)"
//        }
        favoritCountLabel.text = "\(favoritStr)"
    }
}
