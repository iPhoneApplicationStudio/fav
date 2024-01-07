//
//  VenuePhotoCell.swift
//  Favorit
//
//  Created by Chris Piazza on 11/29/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit

class VenuePhotoCell: UICollectionViewCell {
    @IBOutlet weak var collectionImageView: UIImageView!
    
    var photoURLString: String? {
        didSet {
            setUpVenuePhoto()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    func setUpVenuePhoto() {
        guard let photoURLString else {
            return
        }
        
        let photoUrl = URL(string: photoURLString)
        collectionImageView.clipsToBounds = true
        collectionImageView.kf.setImage(with: photoUrl, 
                                        options: [.transition(.fade(0.5)),
                                                  .forceTransition])
    }
    
}
