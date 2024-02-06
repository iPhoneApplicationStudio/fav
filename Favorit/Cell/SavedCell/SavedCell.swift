//
//  SavedCell.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import Foundation
import UIKit

class SavedCell: UITableViewCell {
    static let height: CGFloat = 180
    
    //MARK: IBOutlet
    @IBOutlet weak var primaryTipLabel: UILabel!
    @IBOutlet weak var favoritCountLabel: UILabel!
    @IBOutlet weak var savedCountLabel: UILabel!
    @IBOutlet weak var venueCategoryLabel: UILabel!
    @IBOutlet weak var venueTitleLabel: UILabel!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
    //MARK: Properties
    var place: Place? {
        didSet {
            guard let place else {
                return
            }
            
            self.setUpData(place: place)
        }
    }
            
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        bookmarkImageView.image = UIImage.getTemplateImage(imageName: "bookmark1")
        bookmarkImageView.tintColor = .lightGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        venueImageView.layer.cornerRadius = 5.0
        venueImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        self.starImageView.isHidden = true
    }

    //MARK: Private methods
    private func setUpData(place: Place) {
        self.venueTitleLabel.text = place.name
        self.venueCategoryLabel.text = place.categories?.first?.name ?? ""
        if let photoUrl = URL(string: place.featurePhotoURL ?? place.categoryIconURL ?? "") {
            self.venueImageView.kf.setImage(with: photoUrl,
                                            options: [.transition(.fade(0.5)),
                                                      .forceTransition])
        }
        
        self.primaryTipLabel.text = place.note?.note ?? ""
        self.savedCountLabel.text = "\(place.bookmarkCount ?? 0)"
        self.favoritCountLabel.text = "\(place.favouriteCount ?? 0)"
    }
    
    func configureStarImage() {
        guard let place else {
            return
        }
        
        self.starImageView.isHidden = !place.isFavourite
    }
}
