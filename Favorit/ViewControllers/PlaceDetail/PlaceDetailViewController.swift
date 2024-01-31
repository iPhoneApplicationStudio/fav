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
    func noteUpdatedFor(placeID: String?, note: Note)
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
    private var isEditMode = false
    
    weak var placeDetailDelegate: PlaceDetailDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        self.setupButtonBar()
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
        
        self.setButtonStates()
        self.addGradientToImageView(imageView: headerImageView)
        if viewModel.isPlaceExist {
            self.setScreenData()
            self.fadeInUI()
        }
        
        self.reloadPagerTabStripView()
    }
    
    private func setupButtonBar() {
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
    
    private func setFavouriteState() {
        let imageName = (viewModel?.isFavourite ?? false) ? "star1" : "star0"
        DispatchQueue.main.async {[weak self] in
            self?.favoritButton.setImage(UIImage(named: imageName),
                                         for: .normal)
        }
    }
    
    private func setButtonStates() {
        guard let viewModel else {
            return
        }
        
        DispatchQueue.main.async {
            self.optionsButton.isHidden = !viewModel.isBookmarked
            //        favoritButton.isSelected = venueState == .favorit
        }
    }
    
    private func bookmarkToggleAction(toggle: Bool) {
        self.viewModel?.isBookmarked = toggle
        if toggle == false {
            self.viewModel?.currentNote = nil
        }
        
        self.setButtonStates()
        self.reloadPagerTabStripView()
        NotificationHelper.Post.refreshMyPlaces.fire()
    }
    
    private func showMailComposeView() {
        guard let viewModel,
              let venueName = viewModel.placeName,
              venueName.isNotEmpty else {
            return
        }
        
        
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
            self.showAlert(title: "Email is not set up",
                      message: "Email is not setup on this device. You can reach us by emailing info@cirqitapp.com ") { _ in }
        }
    }
    
    private func removeTheBookmark() {
        guard let viewModel else {
            return
        }

        self.activityIndicatorView.start()
        viewModel.removeToBookmark {[weak self] result in
            self?.activityIndicatorView.stop()
            guard let result else {
                return
            }
            
            switch result {
            case .success(let flag):
                if flag {
                    self?.showAlert(title: "Success",
                                    message: "Bookmark removed successfully.") { _ in
                        self?.placeDetailDelegate?.bookmarkedStateChangedFor(placeID: viewModel.placeID,
                                                                             state: true)
                        self?.bookmarkToggleAction(toggle: false)
                    }
                } else {
                    self?.showError(message: viewModel.errorMessage ?? Message.somethingWentWrong.value)
                }
            case .failure(let error):
                self?.showError(message: error.localizedDescription)
            }
        }
    }
    
    //MARK: IBAction
    @IBAction func favoritButtonPressed(_ sender: Any) {
        guard let viewModel else {
            return
        }
        
        self.activityIndicatorView.start()
        viewModel.toggleVenueFromFavouriteList {[weak self] result in
            self?.activityIndicatorView.stop()
            self?.setFavouriteState()
            self?.placeDetailDelegate?.favouriteStateChangedFor(placeID: viewModel.placeID,
                                                                state: viewModel.isFavourite)
            NotificationHelper.Post.refreshMyPlaces.fire()
        }
    }
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Options",
                                                                         message: nil,
                                                                         preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel",
                                               style: .cancel) { _ in }
        actionSheetController.addAction(cancelActionButton)
        /*let shareAction = UIAlertAction(title: "Share",
         style: .default) { _ in
         self.didClickOnShare()
         }
         
         actionSheetController.addAction(shareAction)*/
        let bookmarkString = viewModel?.isBookmarked ?? false ? "Remove Bookmark" : "Bookmark"
        let bookmarkAction = UIAlertAction(title: bookmarkString,
                                           style: .default) { _ in
            self.showAlertWithYesAndNo(message: "Are you sure to remove venue from bookmark?") { flag in
                if flag {
                    self.removeTheBookmark()
                }
            }
        }
        
        actionSheetController.addAction(bookmarkAction)
        if self.composeTipsVC == nil {
            let editNoteAction = UIAlertAction(title: "Edit Note",
                                               style: .default) { _ in
                self.isEditMode = true
                self.reloadPagerTabStripView()
            }
            
            actionSheetController.addAction(editNoteAction)
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func composePrivateReviewButtonPressed(_ sender: Any) {
        showMailComposeView()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Pager Setup
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        self.composeTipsVC = nil
        if let viewModel = self.viewModel,
           let placeID = viewModel.placeID,
           (!viewModel.isBookmarked || isEditMode) {
            let composeNoteViewModel = ComposeNoteViewModel(placeID: placeID,
                                                            placeName: viewModel.placeName ?? "",
                                                            existingNote: viewModel.currentNote)
            composeTipsVC = ComposeTipViewController.getViewController(viewModel: composeNoteViewModel)
            if isEditMode {
                isEditMode = false
            }
            
            composeTipsVC?.composeTipViewDelegate = self
        }
        
        var viewControllers = [UIViewController]()
        if let placeID = viewModel?.placeID,
           let notesVC = NotesViewController.getViewController(placeID: placeID) {
            notesVC.delegate = self
            viewControllers.append(notesVC)
        }
        
        if let photosVC = PlacePhotoViewController.getViewController(photoURLStrings: viewModel?.photoURLs) {
            viewControllers.append(photosVC)
        }
        
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
    func noteUpdated(note: Note) {
        self.placeDetailDelegate?.bookmarkedStateChangedFor(placeID: viewModel?.placeID,
                                                            state: true)
        self.placeDetailDelegate?.noteUpdatedFor(placeID: viewModel?.placeID,
                                                 note: note)
        self.viewModel?.currentNote = note
        self.bookmarkToggleAction(toggle: true)
    }
    
    func bookmarkedTheVenue() {
        self.placeDetailDelegate?.bookmarkedStateChangedFor(placeID: viewModel?.placeID,
                                                            state: true)
        self.bookmarkToggleAction(toggle: true)
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
