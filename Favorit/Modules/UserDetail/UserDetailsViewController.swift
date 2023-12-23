//
//  UserDetailsViewController.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import UIKit
import NVActivityIndicatorView

enum UserFollowerVCState {
    case followers
    case following
    case myFollowers
    case myFollowing
    case venueFollowing
}

class UserDetailsViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var noVenuesLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var userDetailsView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tagLineTextField: UITextField!
    @IBOutlet weak var favoritCountLabel: UILabel!
    @IBOutlet weak var bookmarkCountLabel: UILabel!
    @IBOutlet weak var userContainerView: UIView!
    @IBOutlet weak var updateUserImageButton: UIButton!
    @IBOutlet weak var updateCoverPhotoButton: UIButton!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var locationTextView: UITextField!
    
    //MARK: Properties
    var viewModel: UserDetailViewProtocol?
    
    var isMyProfile: Bool {
        return viewModel?.isMyProfile ?? false
    }
    
    var user: User? {
        didSet {
            self.title = isMyProfile ? "My Profile" : user?.name
        }
    }
    
    var bookmarkedVenues = [String]()// [SavedVenue]()
    var favoritVenues = [String]()// [SavedVenue]()
        
    private var isUpdatingUserImage = false
    private var isUpdatingCoverImage = false
    
    private var isInEditMode: Bool = false
    @Dependency private var userSessionService: UserSessionService
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Private methods
    private func initialSetting() {
        self.userContainerView.isHidden = true
        let nib = UINib(nibName: CellName.saved.value,
                        bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "savedCell")
        self.tableView.contentInset = .init(top: 0,
                                            left: 0,
                                            bottom: 66,
                                            right: 0)
        self.tableView.tableFooterView = UIView()
        self.setUpUserInfoUI()
        self.tagLineTextField.delegate = self
        self.locationTextView.delegate = self
    }
    
    private func fetchData() {
        guard let viewModel else {
            return
        }
        
        self.handleActivityIndicatorAnimations()
        viewModel.getUserDetail {[weak self] result in
            self?.handleActivityIndicatorAnimations()
            switch result {
            case .success(let user):
                guard let user else {
                    let message = viewModel.errorMessage ?? Message.somethingWentWrong.value
                    self?.showError(message: message)
                    self?.handleResultsUI()
                    return
                }
                
                self?.setupUser(user: user)
                self?.checkIfFollowingUser()
                self?.getVenues()
                self?.handleResultsUI()
                self?.userContainerView.isHidden = false
            case .failure(let error):
                self?.userContainerView.isHidden = true
                self?.showError(message: error.localizedDescription)
            case .none:
                break
            }
        }
    }
    
    private func handleActivityIndicatorAnimations() {
        DispatchQueue.main.async {
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            } else {
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }
        }
    }
    
    private func didClickOnEdit() {
        self.isInEditMode ? self.hideEditModeUI() : self.showEditModeUI()
        self.isInEditMode = !isInEditMode
    }
    
    private func hideEditModeUI() {
        UIView.animate(withDuration: 0.30) {
            self.updateUserImageButton.isHidden = true
            //            self.updateCoverPhotoButton.isHidden = true
            self.tagLineTextField.isEnabled = false
            self.locationTextView.isEnabled = false
            self.tableView.alpha = 1.0
            
            if self.tagLineTextField.text?.count == 0 {
                self.tagLineTextField.isHidden = true
            }
            
            if self.locationTextView.text?.count == 0 {
                self.locationTextView.isHidden = true
            }
        }
    }
    
    private func showEditModeUI() {
        UIView.animate(withDuration: 0.30) {
            self.updateUserImageButton.isHidden = false
            //            self.updateCoverPhotoButton.isHidden = false
            self.tagLineTextField.isEnabled = true
            self.tagLineTextField.isHidden = false
            self.locationTextView.isEnabled = true
            self.locationTextView.isHidden = false
            self.tableView.alpha = 0.0
        }
    }
    
    private func saveChanges() {
        self.didClickOnEdit()
        guard let viewModel,
              let tagLine = self.tagLineTextField.text,
              tagLine.isNotEmpty else {
            return
        }
        
        self.handleActivityIndicatorAnimations()
        viewModel.updateTheUser(tagLine: tagLine) {[weak self] result in
            self?.handleActivityIndicatorAnimations()
            switch result {
            case .success(let status):
                guard status else {
                    let message = viewModel.errorMessage ?? Message.somethingWentWrong.value
                    self?.showError(message: message)
                    return
                }
                
            case .failure(let error):
                self?.showError(message: error.localizedDescription)
            case .none:
                break
            }
        }
        
//        var changesMade = false
//        if !(tagLineTextField.text?.isEmpty)! {
//            let user = FavoritUser.current()
//            user?.tagLine = tagLineTextField.text
//            changesMade = true
//        }
//
//        if !(locationTextView.text?.isEmpty)! {
//            let user = FavoritUser.current()
//            user?.userLocationName = locationTextView.text
//            changesMade = true
//        }
//
    }
        
    private func signOut() {
        guard let viewModel else {
            return
        }
        
        self.showAlertWithYesAndNo(title: "Sign Out Confirmation", 
                                   message: "You are about to sign out of your account. This will end your current session, and any unsaved changes may be lost.",
                                   ok: "Sign Out",
                                   cancel: "Cancel") { status in
            if status {
                let flag = viewModel.signout()
                if flag, let window = UIWindow.topWindow {
                    let flowCoordinator = AppCoordinator(with: window)
                    flowCoordinator.start()
                }
            }
        }
    }
}

// MARK: - Navigation
extension UserDetailsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "toPlaceDetails" {
        //            guard let detailController = segue.destination as? PlaceDetailViewController else {return}
        //            let indexPath = sender as! IndexPath
        //            switch indexPath.section {
        //            case 0:
        //                let favVenue = favoritVenues[indexPath.row]
        //                if !isMyProfile {
        //                    favVenue.venueTip = nil
        //                    favVenue.isFavorit = false
        //                }
        //                detailController.savedVenue = favVenue
        //            default:
        //                let bookmarkVenue = bookmarkedVenues[indexPath.row]
        //                if !isMyProfile {
        //                    bookmarkVenue.venueTip = nil
        //                }
        //                detailController.savedVenue = bookmarkVenue
        //            }
        //        }
        //
        //        if segue.identifier == "toUserFollow" {
        //            guard let userFollowVC = segue.destination as? UserFollowerViewController else {return}
        //            if let userFollowerVCState = sender as? UserFollowerVCState {
        //                userFollowVC.userFollowerVCState = userFollowerVCState
        //            }
        //            userFollowVC.viewdUser = user
        //        }
    }
}

// MARK: Setup
private extension UserDetailsViewController {
    private func setUpUserInfoUI() {
        setupRightBarButton()
        setupFollowButton()
        setupUpdateImageButton()
        //        setupUpdateCoverPhotoButton()
        userImageView.rounded()
        imageContainerView.rounded()
    }
    
    private func setupRightBarButton() {
        if isMyProfile {
            self.setupDotsButton()
        } else {
            self.setupMapButton()
        }
    }
    
    private func setupDotsButton() {
        let dotsButton = UIBarButtonItem(image: UIImage(named: "dotsIcon"),
                                         style: .plain,
                                         target: self,
                                         action:  #selector(dotsMenuTapped))
        self.navigationItem.rightBarButtonItem = dotsButton
    }
    
    private func setupMapButton() {
        let image = UIImage(named: "map")?.withRenderingMode(.alwaysOriginal)
        let mapButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(mapButtonPressed))
        self.navigationItem.rightBarButtonItem  = mapButton
    }
    
    private func setupFollowButton() {
        if isMyProfile {
            followButton.isHidden = true
            return
        }
        
        followButton.rounded(with: 3)
        followButton.addBorder(color: .primary, width: 1)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
        followButton.setBackgroundColor(color: .primary, forState: .selected)
        followButton.setTitleColor(.white, for: .selected)
    }
    
    private func setupUpdateImageButton() {
        updateUserImageButton.rounded()
        updateUserImageButton.addBorder(color: .white, width: 1)
        updateUserImageButton.backgroundColor = updateUserImageButton.backgroundColor?.withAlphaComponent(0.50)
        updateUserImageButton.isHidden = true
    }
    
    private func setupUpdateCoverPhotoButton() {
        updateCoverPhotoButton.layer.cornerRadius = 3.0
        updateCoverPhotoButton.layer.borderWidth = 1.0
        updateCoverPhotoButton.layer.borderColor = UIColor.white.cgColor
        updateCoverPhotoButton.isHidden = true
    }
    
    func fadeInUI(){
        UIView.animate(withDuration: 1.5, animations: {
            self.tableView.alpha = 1.0
            self.userContainerView.alpha = 1.0
        })
    }

    
    func handleResultsUI() {
        DispatchQueue.main.async {
            if self.favoritVenues.count == 0
                && self.bookmarkedVenues.count == 0 {
                self.setNoVenuesLabel()
                self.noVenuesLabel.isHidden = false
                self.tableView.isHidden = true
                self.fadeInNoVenuesLabel()
            } else {
                if !self.noVenuesLabel.isHidden {
                    self.noVenuesLabel.isHidden = true
                    self.tableView.isHidden = false
                }
                
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
            
            self.fadeInUI()
        }
    }
    
    func setNoVenuesLabel() {
        if isMyProfile {
            self.noVenuesLabel.text = StringConstants.PlacesEmptyResultsStrings.myPlacesEmpty
        } else {
            let userFullNameName = user?.name ?? "This user"
            self.noVenuesLabel.text = "\(userFullNameName) \(StringConstants.PlacesEmptyResultsStrings.profileEmpty)"
        }
    }
    
    func fadeInNoVenuesLabel() {
        UIView.animate(withDuration: 1.5, animations: {
            self.noVenuesLabel.alpha = 1.0
        })
        
    }
    
    func updateImageButtonTapped() {
        let alert = UIAlertController(title: "Please choose an image", message: nil, preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
            self.presentCameraPickerController()
        }))
        
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler:{ (UIAlertAction)in
            self.presentPhotoPickerController()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    //MARK: Edit Mode
    
    func saveImage(image: UIImage, 
                   isCover: Bool) {
        self.handleActivityIndicatorAnimations()
        navigationItem.rightBarButtonItem?.isEnabled = false
        //        updateCoverPhotoButton.isEnabled = false
        updateUserImageButton.isEnabled = false
        
        //        var photoType = String()
        //        if isCover {
        //            photoType = "coverPhoto"
        //        } else {
        //            photoType = "userPhoto"
        //        }
        //
        //        let imageData = image.jpegData(compressionQuality: 0.50)
        //        let imageFile = PFFileObject(name:"image.png", data:imageData!)
        //
        //        guard let user = FavoritUser.current() else {
        //            return
        //        }
        //        user[photoType] = imageFile
        //        userService.saveUserImage(user: user) { (success, error) in
        //            self.isUpdatingUserImage = false
        //            if error == nil {
        //                print("Saved Photo")
        //                self.didClickOnEdit()
        //                self.handleActivityIndicatorAnimations()
        //                self.navigationItem.rightBarButtonItem?.isEnabled = true
        //                self.updateCoverPhotoButton.isEnabled = true
        //                self.updateUserImageButton.isEnabled = true
        //            } else {
        //                self.showError(message: "Error Saving Image \(error.debugDescription)")
        //            }
        //        }
    }
    
    func setFollowerVCState() ->  UserFollowerVCState {
        if isMyProfile {
            return UserFollowerVCState.myFollowers
        } else {
            return UserFollowerVCState.followers
        }
    }
    
    func setFollowintVCState() ->  UserFollowerVCState {
        if isMyProfile {
            return UserFollowerVCState.myFollowing
        } else {
            return UserFollowerVCState.following
        }
    }
    
}

// MARK: - Actions
extension UserDetailsViewController {
    @objc func dotsMenuTapped() {
        let title = isInEditMode ? "Save" : "Edit"
        let alert = UIAlertController(title: "Choose an option",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: title,
                                      style: .default ,
                                      handler:{ (UIAlertAction)in
            self.isInEditMode ? self.saveChanges() : self.didClickOnEdit()
        }))
        
        if !isInEditMode {
            alert.addAction(UIAlertAction(title: "Map",
                                          style: .default,
                                          handler:{ (UIAlertAction)in
                self.mapButtonPressed()
            }))
        }
        
        
        alert.addAction(UIAlertAction(title: "Sign Out",
                                      style: .destructive,
                                      handler:{ (UIAlertAction)in
            self.signOut()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler:{ (UIAlertAction)in
            if self.isInEditMode {
                self.didClickOnEdit()
            }
        }))
        
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        self.handleFollowButtonToggle()
    }
    
    private func handleFollowButtonToggle() {
        guard let viewModel else {
            return
        }
        
        if followButton.isSelected == true {
            if let followerCount = Int(followersCountLabel.text!) {
                let newCount = followerCount - 1
                followersCountLabel.text = "\(newCount)"
            }
            
            followButton.isSelected = false
            unfollowUser(viewModel: viewModel)
        } else {
            if let followerCount = Int(followersCountLabel.text!) {
                let newCount = followerCount + 1
                followersCountLabel.text = "\(newCount)"
            }
            
            followButton.isSelected = true
            followeUser(viewModel: viewModel)
        }
    }
    
    @IBAction func followingButtonTapped(_ sender: Any) {
        let followingState = setFollowintVCState()
        performSegue(withIdentifier: "toUserFollow", sender: followingState)
    }
    
    @IBAction func followersButtonTapped(_ sender: Any) {
        let followerState = setFollowerVCState()
        performSegue(withIdentifier: "toUserFollow", sender: followerState)
    }
    
    @IBAction func updateUserButtonTapped(_ sender: Any) {
        self.isUpdatingUserImage = true
        self.updateImageButtonTapped()
    }
    
    @IBAction func updateCoverPhotoButtonTapped(_ sender: Any) {
        self.isUpdatingCoverImage = true
        self.updateImageButtonTapped()
    }
    
    @objc func mapButtonPressed() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let showOnMapVC = mainStoryboard.instantiateViewController(withIdentifier: "ShowOnMapViewController") as! ShowOnMapViewController
        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            showOnMapVC.isfromProfile = true
            var combinedVenues = self.bookmarkedVenues
            combinedVenues.append(contentsOf: self.favoritVenues)
            
            //            showOnMapVC.userVenues = combinedVenues
            self.navigationController?.pushViewController(showOnMapVC, animated: false)
        }, completion: nil)
    }
}

//MARK: - User Management
extension UserDetailsViewController {
    func setupUser(user: User) {
        self.user = user
        let userFullName = user.name
        let followerCount = user.followerCount ?? 0
        let followingCount = user.followingCount ?? 0
        let favoritCount = user.favouriteCount ?? 0
        let bookmarkCount = user.bookmarkCount ?? 0
        
        self.usernameLabel.text = userFullName
        self.followersCountLabel.text = String(followerCount)
        self.followingCountLabel.text = String(followingCount)
        self.favoritCountLabel.textColor = .accentColor
        self.favoritCountLabel.text = String(favoritCount)
        self.bookmarkCountLabel.text = String(bookmarkCount)
        self.followButton.isSelected = viewModel?.isFollowedByMe ?? false
        
        userImageView.setImage(
            from: user.avatar,
            placeholder: .init(
                text: user.name,
                fontSize: 30,
                backgroundColor: .random,
                isCircular: true,
                fontWeight: .light,
                textColor: .white))
        
        if let tagLine = self.user?.bio,
           tagLine.isNotEmpty {
            self.tagLineTextField.text = tagLine
            self.tagLineTextField.isHidden = false
        } else {
            self.tagLineTextField.isHidden = true
        }
        
        // coverImageView ?
        
        
        //        if let userLocationName = self.user?.userLocationName {
        //            self.locationTextView.text = userLocationName
        //            self.locationTextView.isHidden = false
        //        }
    }
    
    //    func handleCompletedSignOut() {
    //        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    //        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationKeys.userSignOutNotification), object: nil)
    //    }
    
    func getVenues() {
        //        let params: [String:String] = [
        //            "userObjectId" : userId]
        //        let services = VenueServices()
        //        services.getUserVenues(params: params) { (favorits, bookmarked, error) in
        //            if error == nil {
        //                if self.favoritVenues.count > 0 {
        //                    self.favoritVenues.removeAll()
        //                }
        //                if let favoritsVenues = favorits, favoritsVenues.count > 0 {
        //                    self.favoritVenues = DistanceHelper.addDistanceFromUserAndSort(venueArray: favoritsVenues)
        //                }
        //
        //                if self.bookmarkedVenues.count > 0 {
        //                    self.bookmarkedVenues.removeAll()
        //                }
        //
        //                if let bookmarkedVenues = bookmarked, bookmarkedVenues.count > 0 {
        //                    self.bookmarkedVenues = DistanceHelper.addDistanceFromUserAndSort(venueArray: bookmarkedVenues)
        //                }
        //
        //            } else {
        //
        //                self.showError(message: (error?.localizedDescription)!)
        //                print(error!)
        //            }
        //
        //            self.handleActivityIndicatorAnimations()
        //            self.handleResultsUI()
        //        }
    }
    
    func checkIfFollowingUser() {
        //        userService.checkIfUserIsFollowed(toUser: self.user!) { (follow, isFollowed, error) in
        //            if error == nil {
        //                self.followButton.isSelected = isFollowed
        //                if !self.followButton.isEnabled {
        //                    self.followButton.isEnabled = true
        //                }
        //                if let follow = follow {
        //                    self.follow = follow
        //                }
        //            } else {
        //                self.showError(message: "There was an error \(error?.localizedDescription)")
        //            }
        //        }
    }
    
    func followeUser(viewModel: UserDetailViewProtocol) {
        viewModel.followTheUser {[weak self] result in
            switch result {
            case .success(let status):
                if status {
                    self?.followButton.isSelected = true
                    //self.checkIfFollowingUser()
                } else {
                    self?.showError(message: viewModel.errorMessage ?? "")
                }
                
            case .failure(let error):
                self?.showError(message: "There was an error \(error.localizedDescription)")
            case .none:
                return
            }
        }
    }
    
    func unfollowUser(viewModel: UserDetailViewProtocol) {
        viewModel.unFollowTheUser {[weak self] result in
            switch result {
            case .success(let status):
                if status {
                    self?.followButton.isSelected = false
                } else {
                    self?.showError(message: viewModel.errorMessage ?? "")
                }
            case .failure(let error):
                self?.showError(message: "There was an error \(error.localizedDescription)")
            case .none:
                return
            }
        }
    }
}

//MARK: ImagePickerDelegate
extension UserDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentCameraPickerController() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func presentPhotoPickerController() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if isUpdatingUserImage {
                userImageView.image = pickedImage
                saveImage(image: pickedImage, isCover: false)
            } else {
                coverImageView.image = pickedImage
                saveImage(image: pickedImage, isCover: true)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: UITableView Delegate & DataSource
extension UserDetailsViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return favoritVenues.count
        default:
            return bookmarkedVenues.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell") as! SavedCell
        cell.selectionStyle = .none
        //        let venue: SavedVenue?
        
        switch indexPath.section {
        case 0:
            //            venue = favoritVenues[indexPath.row]
            //            cell.savedVenue = venue
            cell.starImageView.isHidden = false
        default:
            break
            //            venue = bookmarkedVenues[indexPath.row]
            //            cell.savedVenue = venue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPlaceDetails", sender: indexPath)
    }
}

// MARK: UITextFieldDelegate
extension UserDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UserDetailsViewController {
    static func createViewController() -> UserDetailsViewController? {
        guard let vc = UIStoryboard(name: StoryboardName.main.value,
                                    bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.userDetail.value) as? UserDetailsViewController else {
            return nil
        }
        
        return vc
    }
}
