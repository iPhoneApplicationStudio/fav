//
//  NewsFeedCell.swift
//  Favorit
//
//  Created by Chris Piazza on 7/17/18.
//  Copyright © 2018 Bushman Studio. All rights reserved.
//

import UIKit

class NewsFeedCell: UITableViewCell {
    //MARK: IBOutlet
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var postingUserLabel: UILabel!
    @IBOutlet weak var urlLinkTextView: UITextView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var newsDetailsStackView: UIStackView!
    
    //MARK: Properties
    var delegate: TimelineCellDelegate?
    
    var usernameRange: NSRange?
    var actionTargetRange: NSRange?
//    var actionType: ActionType?
    
//    var timeline: UserTimeline! {
//        didSet {
//            setUpCell()
//        }
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        actionLabel.text = ""
        postingUserLabel.text = ""
        urlLinkTextView.text = ""
        timeStampLabel.text = ""
        userImageView.gestureRecognizers?.removeAll()
        postingUserLabel.gestureRecognizers?.removeAll()
        actionLabel.gestureRecognizers?.removeAll()
        contentView.gestureRecognizers?.removeAll()
    }
    
//    func setUpCell(){
//        guard let timelineAction = timeline?.action else {
//            return
//        }
//        
//        setupPostingUser(timelineAction: timelineAction)
//        setUserPhoto(timelineAction: timelineAction)
//        setupVenueDetails(timelineAction: timelineAction)
//        if let linkUrlStr = timelineAction.linkUrl {
//            setUrlString(linkUrlStr: linkUrlStr)
//        }
//        if let createdAt = timeline.createdAt {
//            timeStampLabel.text = createdAt.timeAgoSinceDate(numericDates: true)
//        }
//    }
    
//    func setupPostingUser(timelineAction: TimelineAction) {
//        guard let fullName = timelineAction.userFullName else {return}
//        postingUserLabel.text = fullName
//        setupTapGestures()
//    }
    
//    func setUserPhoto(timelineAction: TimelineAction) {
//        if let userPhotoUrlString = timelineAction.savingUser?.userPhoto?.url {
//            let userPhotoUrl = URL(string: userPhotoUrlString)
//            userImageView.kf.setImage(with: userPhotoUrl, options: [.transition(.fade(0.5)), .forceTransition])
//        } else if let userPhotoUrlString = timelineAction.savingUser?.userPhotoUrl {
//            let userPhotoUrl = URL(string: userPhotoUrlString)
//            userImageView.kf.setImage(with: userPhotoUrl, options: [.transition(.fade(0.5)), .forceTransition])
//        } else {
//            userImageView?.setImage(string: timelineAction.userFullName, color: .random, circular: true, textAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .light), NSAttributedStringKey.foregroundColor: UIColor.white])
//        }
//    }
    
//    func setupVenueDetails(timelineAction: TimelineAction) {
//        guard let venueName = timelineAction.venueName else {
//            actionLabel.text = setupNewsItemCopy(newsItemCopy: timelineAction.newsItemCopy)
//            return
//        }
//        actionLabel.text = setupNewsItemCopy(newsItemCopy: timelineAction.newsItemCopy)
//    }
    
    func setupNewsItemCopy(newsItemCopy: String?) -> String {
        if let copy = newsItemCopy {
            return copy
        } else {
            return ""
        }
    }
    
    func setupTapGestures() {
        let tapGestureVenue = UITapGestureRecognizer(target: self, action: #selector(venueLabelTapped))
        newsDetailsStackView.addGestureRecognizer(tapGestureVenue)

        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped))
        tapGestureImage.cancelsTouchesInView = false
        userImageView.addGestureRecognizer(tapGestureImage)
    }
    
    @objc func venueLabelTapped(sender: UITapGestureRecognizer) {
//        if (timeline.action?.venueId) != nil {
//            delegate?.timelineActionLabelTapped(isUserTapped: false , tag: self.tag)
//        } else {
//            nameLabelTapped(sender: sender)
//        }
    }
    
    @objc func nameLabelTapped(sender: UITapGestureRecognizer) {
         delegate?.timelineActionLabelTapped(isUserTapped: true , tag: self.tag)
    }
    
    func setUrlString(linkUrlStr: String) {
        let attributedString = NSMutableAttributedString(string: linkUrlStr)
            attributedString.addAttribute(.link, value: linkUrlStr, range: NSRange(location: 0, length: attributedString.length))
        
        urlLinkTextView.attributedText = attributedString
        urlLinkTextView.isHidden = false
        urlLinkTextView.isSelectable = true
        urlLinkTextView.dataDetectorTypes = UIDataDetectorTypes.link
//        urlLinkTextView.tintColor = Constants.Colors.accentColor
    }
}
