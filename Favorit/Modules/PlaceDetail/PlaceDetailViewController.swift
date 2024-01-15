//
//  PlaceDetailViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 11/10/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MessageUI
import NVActivityIndicatorView

protocol SegueHandlerDelegate: AnyObject {
    func segueToProfile(identifier: String, sender: Any)
}

protocol PlaceDetailDelegate: AnyObject {
    func favouriteStateChangedFor(placeID: String?, state: Bool)
    func bookmarkedStateChangedFor(placeID: String?, state: Bool)
}

class PlaceDetailViewController: ButtonBarPagerTabStripViewController, SegueHandlerDelegate {
    //MARK: IBOutlets
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleDetailsView: UIView!
    @IBOutlet weak var favoritButton: UIButton!
    @IBOutlet weak var favoritLabel: UILabel!
    @IBOutlet weak var favoritBalanceLabel: UILabel!
    @IBOutlet weak var bookmarkedLabel: UILabel!
    @IBOutlet weak var venueAddressLabel: UILabel!
    @IBOutlet weak var venueDistanceLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var venueDetailsContainerStackView: UIStackView!
    @IBOutlet weak var bookmarkedCountImageView: UIImageView!
    @IBOutlet weak var composePrivateReviewButton: FloatingAddButton!
    @IBOutlet weak var favoritStackView: UIStackView!
    @IBOutlet weak var bookmarkStackView: UIStackView!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    var composeTipsVC: ComposeTipViewController?
    var viewModel: PlaceDetailProtocol?
    var venueName = ""
    var placeState: PlaceState = .notSaved
    var isEditMode = false
    
    weak var placeDetailDelegate: PlaceDetailDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        setupButtonBar()
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        let addressTapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        //        venueDetailsContainerStackView.addGestureRecognizer(tapGesture)
        
        addressStackView.addGestureRecognizer(addressTapGesture)
        
        let favoritTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoritLabelTapped))
        favoritStackView.addGestureRecognizer(favoritTapGesture)
        
        let bookmarkTapGesture = UITapGestureRecognizer(target: self, action: #selector(bookmarkLabelTapped))
        bookmarkStackView.addGestureRecognizer(bookmarkTapGesture)
        self.initialSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: Private methods
    private func initialSetting() {
        guard let viewModel else {
            return
        }
        
        self.addGradientToImageView(imageView: headerImageView)
        if viewModel.isPlaceExist {
            self.setScreenData()
            self.fadeInUI()
        }
    }
    
    private func setScreenData() {
        guard let viewModel else {
            return
        }
        
        self.nameLabel.text = viewModel.placeName
        self.typeLabel.textColor = .accentColor
        self.typeLabel.text = viewModel.category
        if let photoUrl = viewModel.featuredPhotoURL,
           let photoUrl = URL(string: photoUrl) {
               self.headerImageView.kf.setImage(with: photoUrl,
                                           options: [.transition(.fade(0.5)), .forceTransition])
           }
        
        if let addressString = viewModel.address {
            self.venueAddressLabel.attributedText = NSAttributedString(string: addressString, 
                                                                       attributes:
                                                                        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        }
        
        self.venueDistanceLabel.text = viewModel.distance ?? ""
        self.bookmarkedLabel.text = "\(viewModel.bookmarkCount)"
        self.favoritLabel.text = "\(viewModel.favouriteCount)"
        self.setFavouriteState()
    }
    
    private func startActivityIndicator() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicatorView.isHidden = false
            self?.activityIndicatorView.startAnimating()
        }
    }
    
    private func stopActivityIndicator() {
        DispatchQueue.main.async {[weak self] in
            if self?.activityIndicatorView.isAnimating ?? false {
                self?.activityIndicatorView.isHidden = true
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    private func setFavouriteState() {
        let imageName = (viewModel?.isFavourite ?? false) ? "star1" : "star0"
        DispatchQueue.main.async {[weak self] in
            self?.favoritButton.setImage(UIImage(named: imageName),
                                         for: .normal)
        }
    }
    
    //MARK: IBAction
    @IBAction func favoritButtonPressed(_ sender: Any) {
        guard let viewModel else {
            return
        }
    
        self.startActivityIndicator()
        viewModel.toggleVenueFromFavouriteList {[weak self] result in
            self?.stopActivityIndicator()
            self?.setFavouriteState()
            self?.placeDetailDelegate?.favouriteStateChangedFor(placeID: viewModel.placeID,
                                                            state: viewModel.isFavourite)
        }
    }
    
    
    //MARK: Pager Setup
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if let viewModel {
            if !viewModel.isBookmarked,
               let placeID = viewModel.placeID {
                composeTipsVC = ComposeTipViewController.getViewController(viewModel: ComposeNoteViewModel(placeID: placeID))
                composeTipsVC?.composeTipViewDelegate = self
            }
        }
        
        
        let notesVC = NotesViewController.getViewController(placeID: viewModel?.placeID)
        notesVC?.delegate = self
        
        let photosVC = PlacePhotoViewController.getViewController(photoURLStrings: viewModel?.photoURLs)
        
        //        if savedVenue != nil && savedVenue?.venueTip?.tip != "" {
        //            tipsVC.primaryTip = savedVenue?.venueTip
        //        }
        //        if favoritVenue != nil {
        //            tipsVC.venueId = favoritVenue?.venueId
        //            composeTipsVC?.favoritVenue = favoritVenue
        //            photosVC.venueId = favoritVenue?.venueId
        //        }
        
        //        var vcArray = [tipsVC, photosVC]
        //
        //        if venueState == .notSaved || isEditMode {
        //            vcArray.insert(composeTipsVC!, at: 0)
        //            if isEditMode { //user is editing their note
        //                composeTipsVC?.venueTip = savedVenue?.venueTip
        //                composeTipsVC?.isEditMode = true
        //                isEditMode = false
        //            }
        //        }
        
        //        return vcArray
        
        var viewControllers = [UIViewController]()
        guard let photosVC, let notesVC else {
            return viewControllers
        }
        
        viewControllers.append(notesVC)
        viewControllers.append(photosVC)
        guard let composeTipsVC else {
            return viewControllers
        }
        
        viewControllers.insert(composeTipsVC, at: 0)
        return viewControllers
    }
    
    //MARK: Navigation
    func segueToProfile(identifier: String, sender: Any) {
        self.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "showOnMap" {
                    guard let showOnMapVC = segue.destination as? ShowOnMapViewController else {return}
                    showOnMapVC.place = viewModel?.venue
                }
        //
        //        if segue.identifier == "toUserProfile" {
        //            guard let userDetailsVc = segue.destination as? UserDetailsViewController,
        //                let selectedUserId = sender as? String else {return}
        //            userDetailsVc.userId = selectedUserId
        //        }
        //
        //        if segue.identifier == "toWebVC" {
        //            guard let webVC = segue.destination as? WebViewController,
        //                let url = sender as? URL else {return}
        //            webVC.setURL(url: url)
        //        }
        //
        //        if segue.identifier == "toUserFollower" {
        //            guard let userFollowerVC = segue.destination as? UserFollowerViewController,
        //                  let isFavorit = sender as? Bool else {return}
        //            print("TO USER FOLLOWERRRRRR")
        //
        //            userFollowerVC.isFavorit = isFavorit
        //            userFollowerVC.venueId = favoritVenue?.venueId
        //            userFollowerVC.userFollowerVCState = .venueFollowing
        //        }
    }
    
}

private extension PlaceDetailViewController {
    @objc func addressTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showOnMap", sender: nil)
    }
    
    @objc func favoritLabelTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toUserFollower", sender: true)
        
    }
    
    @objc func bookmarkLabelTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toUserFollower", sender: false)
        
    }
    
    func launchLoginScreen() {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        present(viewController, animated: true, completion: nil)
    }
    
    //MARK: UI Setup
    func setupButtonBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .primaryColor ?? .black
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 15, weight:UIFont.Weight.thin)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .accentColor
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 8
        settings.style.buttonBarRightContentInset = 8
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .primaryColor
            newCell?.label.textColor = .accentColor
        }
    }
    
    func isVenueFavoritOrSaved() {
        //        if let venue = favoritVenue {
        //            let services = VenueServices()
        //            services.checkIfVenueIsSaved(favoritVenue: venue) { (venueState, savedVenue, /*isFavorit, isBookmark,*/ error) in
        //                if venueState == .notSignedIn {
        //                    self.reloadPagerTabStripView()
        //                    self.setButtonStates()
        //                    self.fadeInUI()
        //                } else if error == nil {
        //                    self.venueState = venueState
        //                    if savedVenue != nil {
        //                        self.savedVenue = savedVenue
        //                    }
        //                    self.reloadPagerTabStripView()
        //                    self.setButtonStates()
        //                    self.fadeInUI()
        //                } else {
        //                    self.showError(message: "\(Constants.ErrorMessages.genericError) \(String(describing: (error?.localizedDescription)))")
        //                }
        //            }
        //        }
    }
    
    
    func setCountLabels() {
        //        if let favoritCount = favoritVenue?.favorits {
        //            favoritLabel.text = "\(favoritCount)"
        //        }
        //        if let bookmarkCount = favoritVenue?.bookmarks {
        //            bookmarkedLabel.text = "\(bookmarkCount)"
        //        }
    }
    
    func setFavoritBalanceLabel() {
        //        if let favoritCountBalance = FavoritUser.current()?.favoritsCount {
        //            let favoritBalance = 10 - favoritCountBalance
        //            favoritBalanceLabel.text = "\(favoritBalance) Left"
        //        }
    }
    
    func handleAddingBookmarkedVenueToFavorits() {
        //        if let bookmarkCount = favoritVenue?.bookmarks {
        //            bookmarkedLabel.text = "\(bookmarkCount)"
        //        }
        //        savedVenue?.isFavorit = true
        //        venueState = .favorit
    }
    
    func setupVenueUI(isNewVenue: Bool) {
        setupUI()
        if isNewVenue {
            print("isNewVenue \(isNewVenue)")
            setButtonStates()
            reloadPagerTabStripView()
            fadeInUI()
        } else {
            isVenueFavoritOrSaved() //check if user saved this venue
        }
    }
    
    func setupUI() {
        setScreenData()
        setupVenueCountLabels()
    }
    
    func setButtonStates() {
        //        optionsButton.isHidden = venueState == .notSaved
        //        favoritButton.isSelected = venueState == .favorit
    }
    
    func setupVenueCountLabels() {
        //        var favStr = "0"
        //        if let favoritCount = favoritVenue?.favorits {
        //            favStr = "\(favoritCount)"
        //        }
        //
        //        var bookmarkStr = "0"
        //        if let followCount = favoritVenue?.bookmarks {
        //            bookmarkStr = "\(followCount)"
        //        }
        //        favoritLabel.text = favStr
        //        bookmarkedLabel.text = bookmarkStr
        bookmarkedCountImageView.tintColor = .lightGray
    }
    
    func addGradientToImageView(imageView: UIImageView) {
        let container = UIView(frame: imageView.frame)
        container.applyTopToBottomWhiteGradient()

        headerImageView.superview?.insertSubview(container, aboveSubview: imageView)
        container.isUserInteractionEnabled = false
    }
    
    func fadeInUI(){
        UIView.animate(withDuration: 1.5, animations: {
            self.titleDetailsView.alpha = 1.0
            self.containerView.alpha = 1.0
            self.buttonBarView.alpha = 1.0
        })
    }
    
    func fadeFavoritCountLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.favoritBalanceLabel.alpha = 1.0
        })
    }
    
    func resetViews() {
        self.titleDetailsView.alpha = 0.0
        self.containerView.alpha = 0.0
        self.buttonBarView.alpha = 0.0
    }
    
    //MARK: Venue Management
    func getFavoritVenueDetails() {
        //        let services = VenueServices()
        //        services.getVenueDetails(venueId: (venue?.venueId)!) { (favVenue, error) in
        //            if error == nil {
        //                if let venue = favVenue {
        //                    self.favoritVenue = venue
        //                    self.venue = nil
        //                    self.setupVenueUI(isNewVenue: false) //Setup Venue UI
        //                } else {
        //                    self.setFavoritVenueDetails() //setup FavoritVenue PFObject if there is not already one on the database
        //                }
        //            } else {
        //                print("ERROR \(error)")
        //            }
        //        }
    }
    
    func setFavoritVenueDetails() {
        //        getPhotos(venue: venue!)
    }
    
    //    func getPhotos(venue: Venue) {
    //        let service = VenueServices()
    //        service.getVenuePhotos(venueID: venue.venueId!) { (photos, errorCode, errorMessage) in
    //            if photos != nil {
    //                venue.featuredPhotos = photos!
    //                let favoriteVenueDetails = FavoritVenue(venue: venue)
    //                self.favoritVenue = favoriteVenueDetails
    //                self.setupVenueUI(isNewVenue: true) //Setup Venue UI
    //
    //            } else {
    //                print("Photos Error Code \(String(describing: errorCode))")
    //            }
    //        }
    //    }
    
    func setVenueAsFavorit() {
        //        guard let user = FavoritUser.current(), user.favoritsCount < 10 else {
        //            self.showError(message: "You cannot have more than 10 Favorits")
        //            return
        //        }
        //        updateCount(type: Constants.VenueRelationType.favoritRelation, incriment: 1)
        //        if venueState == .bookmark {
        //            handleAddingBookmarkedVenueToFavorits()
        //            updateSavedVenue()
        //        } else {
        //            updateCount(type: Constants.VenueRelationType.bookmarkRelation, incriment: 1)
        //            configureObjectsToSave()
        //        }
        //        setCountLabels()
        //        setFavoritBalanceLabel()
    }
    
    func removeVenueAsFavorit() {
        //        updateCount(type: Constants.VenueRelationType.favoritRelation, incriment: -1)
        //        setCountLabels()
        //        setFavoritBalanceLabel()
        //        savedVenue?.isFavorit = false
        //        venueState = .bookmark
        //        updateSavedVenue()
    }
    
    func configureObjectsToSave() {
        //        guard let venue = favoritVenue,
        //            let venueId = venue.venueId,
        //            let venueName = venue.name else {
        //                self.showError(message: "Oops, something went wrong. Please try again")
        //                return
        //        }
        //        var objectArray = [] as! [PFObject]
        //        var tipString = Constants.TipStrings.defaultTip
        //        if let composeVC = composeTipsVC {
        //            if composeVC.isValidTip() {
        //                tipString = composeVC.tipTextView.text
        //            }
        //        }
        //        let params: [String:String] = [
        //            "venueTip"  : tipString,
        //            "venueId"   : venueId,
        //            "venueName" : venueName]
        //        let newVenueTip = VenueTips(tip: params)
        //        let savedVenue = SavedVenue(favoritVenue: venue, venueTip: newVenueTip, isFavorit: true)
        //        self.savedVenue = savedVenue
        //        objectArray = [newVenueTip, savedVenue, venue]
        //        //        isBookmark = true
        //        venueState = .favorit
        //        setButtonStates()
        //        setupUI()
        //        saveVenueAsFavorit(objectArray: objectArray)
    }
    
    //    func saveVenueAsFavorit(objectArray: [PFObject]) {
    //        let services = VenueServices()
    //        services.saveVenueAndTip(objectArray: objectArray, type: Constants.VenueRelationType.bookmarkRelation, onCompletion: { (success, error) in
    //            if success {
    //                self.fadeFavoritCountLabel()
    //                self.reloadPagerTabStripView()
    //            } else {
    //                self.showError(message: "ERROR: DID NOT SAVE \(error!.localizedDescription)")
    //            }
    //        })
    //    }
    
    func updateSavedVenue() {
        //        setButtonStates()
        //        reloadPagerTabStripView()
        //        let services = VenueServices()
        //        services.updateSavedVenue(savedVenue: savedVenue!) { (success, error) in
        //            if success {
        //                self.fadeFavoritCountLabel()
        //            }
        //        }
    }
    
    func deleteSavedVenue() {
        //        let services = VenueServices()
        //        services.deleteSavedVenue(favoritVenue: savedVenue?.favoritVenue, savedVenue: savedVenue!) { (success, error) in
        //            if success {
        //                self.venueState = .notSaved
        //                self.navigationController?.popViewController(animated: true)
        //            }
        //        }
    }
    
    //MARK: ActionSheet Functions
    func removeBookmark() {
        //        switch venueState {
        //        case .bookmark:
        //            updateCount(type: Constants.VenueRelationType.bookmarkRelation, incriment: -1)
        //            setCountLabels()
        //        case .favorit:
        //            updateCount(type: Constants.VenueRelationType.favoritRelation, incriment: -1)
        //            updateCount(type: Constants.VenueRelationType.bookmarkRelation, incriment: -1)
        //            setCountLabels()
        //        default:
        //            break
        //        }
        deleteSavedVenue()
    }
    
    func editNote() {
        isEditMode = true
        reloadPagerTabStripView()
    }
    
    func showShareVenuePopup() {
        // Create a custom view controller
        //        let shareVC = ShareDialogViewController(nibName: "ShareDialogViewController", bundle: nil)
        //        if let venueName = favoritVenue?.name {
        //            shareVC.venueName = venueName
        //        }
        //
        //        // Create the dialog
        //        let popup = PopupDialog(viewController: shareVC,
        //                                buttonAlignment: .horizontal,
        //                                transitionStyle: .zoomIn,
        //                                tapGestureDismissal: true,
        //                                panGestureDismissal: false)
        //
        //        // Create first button
        //        let buttonOne = CancelButton(title: "Cancel", height: 60) {
        //        }
        //
        //        // Create second button
        //        let buttonTwo = DefaultButton(title: "Share", height: 60) {
        //            guard let shareText = shareVC.commentTextView.text else {return}
        //            let placeholderString = shareVC.placeholderString
        //            let shareString = self.configureShareText(shareText: shareText, placeholderString: placeholderString)
        //            self.shareVenue(shareText: shareString)
        //        }
        //
        //        buttonTwo.tintColor = Constants.Colors.accentColor
        //
        //        // Add buttons to dialog
        //        popup.addButtons([buttonOne, buttonTwo])
        //
        //        // Present dialog
        //        present(popup, animated: true, completion: nil)
    }
    
    func configureShareText(shareText: String, placeholderString: String) -> String {
        if shareText == placeholderString {
            return ""
        } else {
            return shareText
        }
    }
    
    func shareVenue(shareText: String) {
        //        guard let venueName = favoritVenue?.name,
        //            let venueId = favoritVenue?.venueId,
        //            let fullName = FavoritUser.current()?.fullName else {
        //                self.showError(message: "Oops, something went wrong. Please try again")
        //                return
        //        }
        //        let params: [String : String] = ["userFullName": fullName,
        //                                         "venueName" : venueName,
        //                                         "venueId" : venueId,
        //                                         "shareText": shareText]
        //        let services = VenueServices()
        //        services.shareVenueToUserTimelines(params: params ) { (success, error) in
        //            if success {
        //                let messageString = "You have shared \(venueName) with your followers"
        //                self.showAlert(title: "Success", message: messageString)
        //            } else {
        //                guard let err = error else {
        //                    self.showError(message: "Oops, something went wrong. Please try again")
        //                    return
        //                }
        //                self.showError(message: "shareVenue \(err.localizedDescription)")
        //            }
        //        }
    }
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        var shareAction = UIAlertAction()
        shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showShareVenuePopup()
        }
        actionSheetController.addAction(shareAction)
        
        let bookmarkString = getAlertActionTitles()
        
        var bookmarkAction = UIAlertAction()
        bookmarkAction = UIAlertAction(title: bookmarkString, style: .default) { _ in
            self.removeBookmark()
        }
        actionSheetController.addAction(bookmarkAction)
        
        var editNoteAction = UIAlertAction()
        editNoteAction = UIAlertAction(title: "Edit Note", style: .default) { _ in
            self.editNote()
        }
        actionSheetController.addAction(editNoteAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func composePrivateReviewButtonPressed(_ sender: Any) {
        showMailComposeView()
    }
    
    //MARK: Helper Methods
    func updateCount(type: String, incriment: NSNumber) {
        //        guard let user = FavoritUser.current(),
        //            let venue = favoritVenue else {return}
        //        let countKey = Constants.VenueRelationType.getCountString(relation: type)
        //        print("Count Key \(countKey), type: \(type)")
        //        user.incrementKey(countKey, byAmount: incriment)
        //        venue.incrementKey(type, byAmount: incriment)
    }
    
    func setBookmarkCount(incriment: NSNumber) {
        //        print("Count BOOKMARK -1")
        //        FavoritUser.current()?.incrementKey("bookmarksCount", byAmount: incriment)
        //        savedVenue?.favoritVenue?.incrementKey(Constants.VenueRelationType.bookmarkRelation, byAmount: incriment)
    }
    
    func getAlertActionTitles() -> String {
        var bookmarkStr = "Bookmark"
        //        if venueState != .notSaved {
        //            bookmarkStr = "Remove Bookmark"
        //        }
        return bookmarkStr
    }
    
    //    func showError( message: String) {
    //        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
    //        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { alertAction in
    //
    //        })
    //
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { alertAction in
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLoginScreen() {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        present(viewController, animated: true, completion: nil)
    }
    
    func showMailComposeView() {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "Private Review: \(venueName)"
            let messageBody = "Send a private review directly to \(venueName)"
            let toRecipents = ["info@cirqitapp.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        } else {
            showAlert(title: "Email is not set up", message: "Email is not setup on this device. You can reach us by emailing info@cirqitapp.com ")
        }
    }
    
}

extension PlaceDetailViewController {
    //MARK: Get Venue Details - From Newsfeed
    /*** From Newsfeed ***/
    func getFavoritVenueDetailsWith(venueId: String) {
        print("getFavoritVenueDetailsWith Venue ID \(venueId)")
        
        //        let services = VenueServices()
        //        services.getVenueDetails(venueId: venueId) { (favVenue, error) in
        //            print("getVenueDetails Venue ID \(favVenue), error \(error.debugDescription)")
        //
        //            if error == nil {
        //                if let venue = favVenue {
        //                    self.favoritVenue = venue
        //                }
        //                self.setupVenueUI(isNewVenue: false)
        //            }
        //        }
    }
}

//MARK: MFMailComposeViewControllerDelegate
extension PlaceDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(error?.localizedDescription)")
            if let err = error {
                showError(message: err.localizedDescription)
            }
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PlaceDetailViewController: ComposeTipViewDelegate {
    func bookmarkedStateChangedFor(state: Bool) {
        self.placeDetailDelegate?.bookmarkedStateChangedFor(placeID: viewModel?.placeID,
                                                            state: state)
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlaceDetailViewController {
    static func getViewController(viewModel: PlaceDetailProtocol) -> PlaceDetailViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.main.value,
                                      bundle: nil)
        let placeDetailVC =  storyboard.instantiateViewController(withIdentifier: ViewControllerName.placeDetailVC.value) as? PlaceDetailViewController
        placeDetailVC?.viewModel = viewModel
        return placeDetailVC
    }
}
