//
//  TimelineCell.swift
//  Favorit
//
//  Created by Chris Piazza on 1/29/18.
//  Copyright © 2018 Bushman Studio. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var shareTextLabel: UILabel!
    
    //MARK: Properties
    var delegate: TimelineCellDelegate?
    
    var usernameRange: NSRange?
    var actionTargetRange: NSRange?
    var actionType: FeedActionType!
    
//    var timeline: UserTimeline? {
//        didSet {
//            setUpTimelineCell()
//        }
//    }
    
    override func prepareForReuse() {
        timeStampLabel.text = ""
        actionLabel.gestureRecognizers?.removeAll()
        if !shareTextLabel.isHidden {
            shareTextLabel.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
    }
    
    /*func setUpTimelineCell(){
        guard let userTimeline = timeline,
            let timelineAction = userTimeline.action else {
                return
        }
        actionType = ActionType(rawValue: userTimeline.timelineType!)
        setTimelineActionString(userTimeline: userTimeline, timelineAction: timelineAction)
        print("Action \(timelineAction.description)")
        
        if let createdAt = userTimeline.createdAt?.timeAgoSinceDate(numericDates: true) {
            timeStampLabel.text = createdAt
        }
        
        setUserPhoto(timelineAction: timelineAction)
       
        if actionType == .share {
            setUserShareTextLabel(timelineAction: timelineAction)
        }
        
        if actionType == .bookmark || actionType == .favorit {
            print(".bookmark or .favorit")
            guard let savedVenue = timelineAction.savedVenue,
                let tip = savedVenue.venueTip?.tip,
               tip != Constants.TipStrings.defaultTip else {return}
            
            shareTextLabel.text = tip
            shareTextLabel.isHidden = false
        }
        
    }
    
    func setTimelineActionString(userTimeline: UserTimeline, timelineAction: TimelineAction) {
        guard var actionTarget = actionType.getActionTargetString(action: timelineAction),
            let userFullName = timelineAction.userFullName else {return}
        
        let actionString = NSMutableAttributedString(string: userFullName, attributes: setActionTextAttributes() )
        
        if actionType == .follow &&
            timelineAction.followedUserId == FavoritUser.current()?.objectId {
            actionTarget = "you"
        }
        
        let actionTargetStr = NSMutableAttributedString(string: actionTarget, attributes: setActionTextAttributes() )

        
        let actionMsg = NSAttributedString(string: actionType.actionMessage)
        actionString.append(actionMsg)
        actionString.append(actionTargetStr)
        
        actionLabel.attributedText = NSMutableAttributedString(attributedString: actionString)
        setClickableTextRanges(userFullName: userFullName, actionTarget: actionTarget)
    }
    
    func setClickableTextRanges(userFullName: String, actionTarget: String) {
        if let text = actionLabel.text {
            usernameRange = (text as NSString).range(of: userFullName)
            actionTargetRange = (text as NSString).range(of: actionTarget)
            setupTapGesture()
        }
    }
    
    func setUserPhoto(timelineAction: TimelineAction) {
        if let userPhotoUrlString = timelineAction.savingUser?.userPhoto?.url {
            let userPhotoUrl = URL(string: userPhotoUrlString)
            userImageView.kf.setImage(with: userPhotoUrl, options: [.transition(.fade(0.5)), .forceTransition])
        } else if let userPhotoUrlString = timelineAction.savingUser?.userPhotoUrl {
            let userPhotoUrl = URL(string: userPhotoUrlString)
            userImageView.kf.setImage(with: userPhotoUrl, options: [.transition(.fade(0.5)), .forceTransition])
        } else {
            userImageView?.setImage(string: timelineAction.userFullName, color: .random, circular: true, textAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .light), NSAttributedStringKey.foregroundColor: UIColor.white])
        }
    }
    
    func setUserShareTextLabel(timelineAction: TimelineAction) {
        guard let shareText = timelineAction.shareText else {return}
        if shareText.count > 0 {
            shareTextLabel.text = shareText
            shareTextLabel.isHidden = false
        }
    }
    
    func setActionTextAttributes() -> [NSAttributedStringKey : Any] {
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: Constants.Colors.accentColor,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return attributes
    }
    
    func setDateStampTextAttributes() -> [NSAttributedStringKey : Any] {
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .light)]
        return attributes
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        actionLabel.addGestureRecognizer(tapGesture)
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGestureImage.cancelsTouchesInView = false
        userImageView.addGestureRecognizer(tapGestureImage)
        
    }
    
//    func setupTapGestures() {
//        let tapGestureVenue = UITapGestureRecognizer(target: self, action: #selector(venueLabelTapped))
//        newsDetailsStackView.addGestureRecognizer(tapGestureVenue)
//        
//
//    }
    
    @objc func labelTapped(sender: UITapGestureRecognizer) {
        if sender.didTapAttributedTextInLabel(label: actionLabel, inRange: usernameRange!) {
            print("Tapped usernameRange")
            delegate?.timelineActionLabelTapped(isUserTapped: true , tag: self.tag)
        } else if sender.didTapAttributedTextInLabel(label: actionLabel, inRange: actionTargetRange!) {
            print("Tapped actionLabel")
            delegate?.timelineActionLabelTapped(isUserTapped: false , tag: self.tag)
        } else {
            print("Tapped none")
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        delegate?.timelineActionLabelTapped(isUserTapped: true , tag: self.tag)
    }
    
     */
}

