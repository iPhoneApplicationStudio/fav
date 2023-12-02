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
        tagLineLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
