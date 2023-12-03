//
//  FollowingViewController.swift
//  Favorit
//
//  Created by ONS on 3/28/18.
//  
//

import UIKit
import NVActivityIndicatorView

final class FollowingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notFollowingUsersLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var addFollowerButton: UIButton!
    
    @Dependency private var viewModel: FollowingViewModel
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBindings()
        viewModel.getFollowers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UserDefaults.loggedInUserID = nil
//        KeychainManager.remove(for: UserDefaults.accessTokenKey!)
    }
}

extension FollowingViewController {
    
    private func setup() {
        self.title = "My Followers"
        addFollowerButton.rounded()
    }
    
    private func setupBindings() {
        viewModel.handleLoadingState = { [weak self] flag in
            DispatchQueue.main.async {
                if flag {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        }
        viewModel.didUpdateState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .error(let errorType):
                    self?.showError(message: errorType.message)
                case .loaded:
                    self?.setupLoadedState()
                case .noFollowingUsers:
                    self?.setupEmptyState()
                case .loading: break
                }
            }
        }
    }
}

extension FollowingViewController {
    
    @IBAction func didTapAddNewFollower(_ sender: UIButton) {
        navigationController?.pushViewController(FindUsersViewController.makeFindUsersViewController(), animated: true)
    }
}

//MARK: - Handle UI
private extension FollowingViewController {
    
    func fadeInUI(){
        UIView.animate(withDuration: 1.5, animations: {
            self.tableView.alpha = 1.0
        })
    }
    
    private func setupEmptyState() {
        self.notFollowingUsersLabel.isHidden = false
        self.tableView.isHidden = true
    }
    
    private func setupLoadedState() {
        self.notFollowingUsersLabel.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
        self.fadeInUI()
    }
    
    private func handleActivityIndicatorAnimations() {
        if activityIndicatorView.isAnimating {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
    }
    
    func getAllFollowers() {
        viewModel.getFollowers()
    }
    
}

//MARK: UITableViewDataSource
extension FollowingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellName.followerCell.value) as? FollowerCell else {
            return UITableViewCell()
        }
        let user = viewModel.userForIndex(indexPath.row)
        cell.configure(with: user)
        return cell
    }
}

extension FollowingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let user = viewModel.userForIndex(indexPath.row) else {
            return
        }
        let vc =
        UIStoryboard(name: "UserDetailsViewController", bundle: nil)
            .instantiateViewController(withIdentifier: "UserDetailsViewController")
            as! UserDetailsViewController
        
        vc.userId = user.id
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FollowerCell {
    fileprivate func configure(with user: FollowerUser?) {
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
            userImageView.setImage(string: user.name,
                                   color: UIColor.lightGray,
                                   circular: true,
                                   textAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .light),
                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
}
