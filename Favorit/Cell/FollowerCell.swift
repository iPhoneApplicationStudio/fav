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
    
    var user: UserProtocol? {
        didSet {
            setUpCell()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        userImageView.setRounded()
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
        tagLineLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpCell() {
        guard let user = user else {
            return
        }
        
        userNameLabel.text = user.name
        followersCountLabel.text = "\(user.followers)"
        favoritCountLabel.text = "\(user.following)"
        //        bookmarkCountLabel.text = "\(follower.bookmarksCount)"
        
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
            userImageView.kf.setImage(with: userPhotoUrl, 
                                      options: [.transition(.fade(0.5)), .forceTransition])
        } else {
//            userImageView.setImage(string: follower.name, 
//                                   color: UIColor.lightGray,
//                                   circular: true,
//                                   textAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .light),
//                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
}
