//
//  FollowerCell.swift
//  Favorit
//
//  Created by ONS on 4/13/18.
//  
//

import UIKit
import Kingfisher

class FollowerCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var favoritCountLabel: UILabel!
    @IBOutlet weak var bookmarkCountLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var favoritImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        userImageView.clipsToBounds = true
        
        favoritCountLabel.textColor = .lightGray
        bookmarkCountLabel.textColor = .lightGray
        favoritImageView.tintColor = .lightGray
        bookmarkImageView.tintColor = .lightGray
    }
    
    override func prepareForReuse() {
        userImageView.image = nil
        userNameLabel.text = ""
        followersCountLabel.text = ""
        favoritCountLabel.text = ""
        bookmarkCountLabel.text = ""
        tagLineLabel.text = "This is my optional tag line"
    }
    
    func configure(with user: User?) {
        guard let user else {
            return
        }
        
        self.userNameLabel.text = user.name
        self.followersCountLabel.text = "\(user.followerCount ?? 0)"
        self.favoritCountLabel.text = "\(user.favouriteCount ?? 0)"
        self.bookmarkCountLabel.text = "\(user.bookmarkCount ?? 0)"
        
        //        if let tagline = follower.tagLine {
        //            tagLineLabel.isHidden = false
        //            tagLineLabel.text = tagline
        //        } else {
        //            tagLineLabel.isHidden = true
        //        }
        
        //        if let userPhoto = follower.userPhoto {
        //            userImageView.file = userPhoto
        //            userImageView.loadInBackground()
        //        } else
        
        if let userPhotoUrlString = user.avatar,
           let userPhotoUrl = URL(string: userPhotoUrlString) {
            self.userImageView.kf.setImage(with: userPhotoUrl,
                                      options: [.transition(.fade(0.5)), .forceTransition]) { [weak userImageView] result in
                switch result {
                case .success: break
                case .failure:
                    userImageView?.setImage(string: user.name,
                                            color: UIColor.lightGray,
                                            circular: true,
                                            textAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .light),
                                                             NSAttributedString.Key.foregroundColor: UIColor.white])
                }
            }
        } else {
            self.userImageView.setImage(string: user.name,
                                   color: UIColor.lightGray,
                                   circular: true,
                                   textAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .light),
                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
}
