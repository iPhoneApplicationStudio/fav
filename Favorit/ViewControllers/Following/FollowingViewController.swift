//
//  FollowingViewController.swift
//  Favorit
//
//  Created by ONS on 3/28/18.
//  
//

import UIKit
import NVActivityIndicatorView

class FollowingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notFollowingUsersLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //    var followedUsers = [Following]()
    private var shouldRefresh = false
    private var viewModel: FollowingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
        setUsers()
        setNotificationisteners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        if shouldRefresh {
            setUsers()
            shouldRefresh = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initialSetting() {
        viewModel = FollowingViewModel()
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 66,
                                              right: 0)
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "toDetails" {
    //            let userDetailsVC = segue.destination as! UserDetailsViewController
    //            guard let follower = sender as? FavoritUser else {
    //                let userId = FavoritUser.current()?.objectId
    //                userDetailsVC.userId = userId
    //                userDetailsVC.isMyProfile = true
    //                return
    //            }
    //            userDetailsVC.userId = follower.objectId
    //        }
    //    }
}

private extension FollowingViewController {
    //MARK: Handle UI
    func fadeInUI(){
        UIView.animate(withDuration: 1.5, animations: {
            self.tableView.alpha = 1.0
        })
    }
    
    func handleResultsUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        if viewModel.numberOfUsers == 0 {
            self.notFollowingUsersLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            if !self.notFollowingUsersLabel.isHidden {
                self.notFollowingUsersLabel.isHidden = true
                self.tableView.isHidden = false
            }
            
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
            self.fadeInUI()
        }
    }
    
    private func handleActivityIndicatorAnimations() {
        if activityIndicatorView.isAnimating {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
    }
    
    //MARK: NotificationCenter
    func setNotificationisteners() {
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadUsers), name: NSNotification.Name(rawValue: Constants.NotificationKeys.reloadUsers), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(userAuthChanged),
//                                               name: NSNotification.Name(rawValue: Constants.NotificationKeys.userSignOutNotification),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(userAuthChanged),
//                                               name: NSNotification.Name(rawValue: Constants.NotificationKeys.userSignInNotification),
//                                               object: nil)
    }
    
    //MARK: User Management
    @objc func reloadUsers() {
        shouldRefresh = true
    }
    
    @objc func userAuthChanged() {
        setUsers()
    }
    
    func setUsers() {
//        if isLoggedIn() {
//            getFollowers()
//        } else {
//            resetFollowersArray()
//            handleResultsUI()
//        }
    }
    
    func resetFollowersArray() {
//        if followedUsers.count > 0 {
//            followedUsers.removeAll()
//        }
    }
    
    private func getAllFollowers() {
        guard let viewModel = viewModel else {
            return
        }
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        //Api call
        viewModel.getAllUsers {[weak self] result in
            self?.handleActivityIndicatorAnimations()
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.handleResultsUI()
                }
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
            case .none:
                break
            }
        }
    }
    
}

//MARK: UITableView Delegate & DataSource
extension FollowingViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellName.followerCell.value) as? FollowerCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.user = viewModel.userForIndex(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        
        let follower = viewModel.userForIndex(indexPath.row)
//        performSegue(withIdentifier: "toDetails", sender: follower.to)
    }
}
