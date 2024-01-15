//
//  TipsCell.swift
//  Favorit
//
//  Created by Chris Piazza on 11/17/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit

class TipsCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userBookmarksLabel: UILabel!
    @IBOutlet weak var userFollowersLabel: UILabel!
    @IBOutlet weak var userFavoritsLabel: UILabel!
    @IBOutlet weak var tipTextView: UITextView!
    
    var note: Note? {
        didSet {
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        tipTextView.textContainerInset = .zero
        tipTextView.contentInset = UIEdgeInsets(top: 0,
                                                left: -5,
                                                bottom: 0,
                                                right: 0)
        tipTextView.tintColor = .accentColor
        tipTextView.isScrollEnabled = false

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        self.layer.cornerRadius = 5.0
        let cellShadowPath = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = cellShadowPath.cgPath

    }
    
    func setupCell() {
        guard let note = note else {
            return
        }
        
        usernameLabel.text = note.user?.name
        tipTextView.text = note.note
        tipTextView.translatesAutoresizingMaskIntoConstraints = true
        tipTextView.sizeToFit()
        
        if let followerCount = note.user?.followerCount {
            userFollowersLabel.text = "\(followerCount)"
        }
        
        if let bookmarksCount = note.user?.bookmarkCount {
            userBookmarksLabel.text = "\(bookmarksCount)"
        }
        
        if let favoritsCount = note.user?.favouriteCount {
            userFavoritsLabel.text = "\(favoritsCount)"
        }
    }
}
