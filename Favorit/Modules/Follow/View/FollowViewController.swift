//
//  FollowingViewController.swift
//  Favorit
//
//  Created by ONS on 3/28/18.
//  
//

import UIKit
import NVActivityIndicatorView

final class FollowViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noUsersLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var followButton: UIButton!
    
    var viewModel: FollowProtocol?
    private var filterMode: FollowType = .following
    private var shouldRefresh = false
    @Dependency private var userSessionService: UserSessionService
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
        self.setupBindings()
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: Private Methods
    private func initialSetting() {
        self.title = viewModel?.title ?? ""
        self.followButton.rounded()
        self.tableView.addSubview(refreshControl)
    }
    
    private func setupBindings() {
        guard let viewModel else {
            return
        }
        
        viewModel.handleLoadingState = { [weak self] flag in
            DispatchQueue.main.async {
                if flag {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                    if self?.refreshControl.isRefreshing ?? true {
                        self?.refreshControl.endRefreshing()
                    }
                }
            }
        }
        
        viewModel.didUpdateState = { [weak self] state in
            self?.shouldRefresh = false
            DispatchQueue.main.async {
                switch state {
                case .error(let errorType):
                    self?.showError(message: errorType.message)
                case .loaded:
                    self?.setupLoadedState()
                case .noUsers:
                    self?.setupEmptyState()
                case .loading: 
                    break
                }
            }
        }
    }
    
    private func setupEmptyState() {
        DispatchQueue.main.async {[weak self] in
            self?.noUsersLabel.isHidden = false
            self?.tableView.isHidden = true
        }
    }
    
    private func setupLoadedState() {
        DispatchQueue.main.async {[weak self] in
            self?.noUsersLabel.isHidden = true
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
            self?.tableView.setContentOffset(CGPoint.zero, animated: true)
            self?.fadeInUI()
        }
    }
    
    private func handleActivityIndicatorAnimations() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicatorView.isHidden = true
            self?.activityIndicatorView.stopAnimating()
        }
    }
    
    private func fadeInUI(){
        DispatchQueue.main.async {[weak self] in
            UIView.animate(withDuration: 1.5, animations: {
                self?.tableView.alpha = 1.0
            })
        }
    }
    
    private func openUserDetailScreen(for userID: String?) {
        guard let userID = userID,
              let vc = UserDetailsViewController.createViewController() else {
            return
        }
        
        let userDetailViewModel = UserDetailViewModel(userID: userID)
        vc.viewModel = userDetailViewModel
        self.navigationController?.pushViewController(vc,
                                                      animated: true)
    }
    
    private func fetchData() {
        guard let viewModel else {
            return
        }
        
        switch filterMode
        {
        case .following:
            viewModel.getFollowingUsers(shouldRefresh: self.shouldRefresh)
        case .follower:
            self.filterMode = .follower
            viewModel.getFollowerUsers(shouldRefresh: self.shouldRefresh)
        }
    }
    
    @objc private func refreshList() {
        self.shouldRefresh = true
        self.fetchData()
    }
    
    //MARK: IBAction
    @IBAction func didTapAddNewFollower(_ sender: UIButton) {
        guard let vc = FindUsersViewController.makeFindUsersViewController() else {
            return
        }
        
        self.navigationController?.pushViewController(vc,
                                                      animated: true)
    }
    
    @IBAction func didClickOnProfile() {
        self.openUserDetailScreen(for: userSessionService.loggedInUserID)
    }
}

//MARK: UITableViewDataSource UITableViewDelegate
extension FollowViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else {
            return 0
        }
        
        return filterMode == .follower ? viewModel.numberOfFollowerUsers : viewModel.numberOfFollowingUsers
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: CellName.followerCell.value) as? FollowerCell else {
            return UITableViewCell()
        }
        
        let user = filterMode == .follower ? viewModel.followerUserForIndex(indexPath.row) : viewModel.followingUserForIndex(indexPath.row)
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let _user = filterMode == .follower ? viewModel?.followerUserForIndex(indexPath.row) : viewModel?.followingUserForIndex(indexPath.row)
        
        guard let user = _user else {
            return
        }
        
        self.openUserDetailScreen(for: user._id)
    }
}
