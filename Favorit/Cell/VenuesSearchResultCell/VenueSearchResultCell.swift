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
    
    var place: Place? {
        didSet {
            self.setUpPlaceData()
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
    
    private func setUpPlaceData() {
        guard let place else {
            return
        }
        
        nameLabel.text = place.name
        if let iconStr = place.categories?.first?.icon,
           let iconUrl = URL(string: iconStr) {
            coverImageView.kf.setImage(with: iconUrl,
                                       options: [.transition(.fade(0.5)), .forceTransition])
        }
        
        addressLabel.text = place.location?.formattedAddress
        venueTypeLabel.text = place.categories?.first?.name
        distanceLabel.text = place.distanceString
    }
}
