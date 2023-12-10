//
//  VenueSearchResultCell.swift
//  Favorit
//
//  Created by Chris Piazza on 11/13/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import Kingfisher

class VenueSearchResultCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var venueTypeLabel: UILabel!
    
    var place: SearchedPlace? {
        didSet {
            self.setUpVenueData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.coverImageView.layer.cornerRadius = 5.0
        self.coverImageView.clipsToBounds = true
    }
    
    private func setUpVenueData() {
        guard let place else {
            return
        }
        
        nameLabel.text = place.name
        
        /*var photoStr = ""
        if let photo = venue?.featuredPhotos.first?.photoUrl {
            photoStr = photo
        } else if let iconPhoto = venue?.primaryCategory?.icon {
            photoStr = iconPhoto
        }
        
        let photoUrl = URL(string: photoStr)
        coverImageView.kf.setImage(with: photoUrl, options: [.transition(.fade(0.5)), .forceTransition])
        
        addressLabel.text = venue?.location?.address
        venueTypeLabel.text = venue?.primaryCategory?.name
        distanceLabel.text = venue?.location?.distanceString*/
    }
}
