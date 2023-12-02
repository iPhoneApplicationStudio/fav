//
//  FindUsersViewController.swift
//  Favorit
//
//  Created by ONS on 12/19/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FindUsersViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var noSearchResultsLabel: UILabel!
    
    let services = AllUsersService()
    
    private var users: [User] = []
    var currentPage: Int = 1
    let itemsPerPage: Int = 5
    var isLoading: Bool = false
    
    private let searchController = UISearchController(searchResultsController: nil)
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = FavoritConstant.Colors.primaryColor
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func initialSetting() {
        //Table View
        tableView.addSubview(refreshControl)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        //UISearchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find Users"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        searchController.searchBar.becomeFirstResponder()
        
        self.noSearchResultsLabel.isHidden = false
        self.tableView.isHidden = true
        
        loadingIndicator.hidesWhenStopped = true
        tableView.tableFooterView = loadingIndicator
    }
    
    @objc func refreshUsers() {
        self.users = []
        self.currentPage = 1
        self.isLoading = false
        searchController.isActive = false
        searchUsers(searchTerm: searchController.searchBar.text ?? "")
    }
    
    func searchUsers(searchTerm: String) {
        guard !isLoading else {
            return
        }
        isLoading = true
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        if currentPage > 1 {
            loadingIndicator.startAnimating()
        }
        let request = AllUsersRequest(queryParams: AllUsersRequest.RequestParams(
            search: searchTerm,
            page: currentPage,
            limit: itemsPerPage,
            sortOrder: "asc"))
        services.getAllUsers(request: request) { [weak self] result in
            self?.loadingIndicator.stopAnimating()
            self?.activityIndicatorView.isHidden = true
            self?.activityIndicatorView.stopAnimating()
            switch result {
            case .success(let success):
                self?.users += success.data ?? []
                self?.currentPage += 1
                self?.isLoading = false
                self?.handleResultsUI()
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
                self?.isLoading = false
            }
            self?.refreshControl.endRefreshing()
        }
    }
    
    func handleResultsUI() {
        if users.isEmpty {
            self.noSearchResultsLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            if !self.noSearchResultsLabel.isHidden {
                self.noSearchResultsLabel.isHidden = true
                self.tableView.isHidden = false
            }
            
        }
    }
    
    func handleActivityIndicatorAnimations() {
        if activityIndicatorView.isAnimating {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: Search Controller Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.users = []
        self.currentPage = 1
        self.isLoading = false
        if let searchTerm = searchBar.text {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            searchUsers(searchTerm: searchTerm)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //
        //        if segue.identifier == "searchToUserProfile" {
        //            let userDetailsVC = segue.destination as! UserDetailsViewController
        //            guard let indexPath = sender as? IndexPath else {return}
        //            let user = users[indexPath.row]
        //            userDetailsVC.userId = user.objectId
        //        }
    }
    
    
}

extension FindUsersViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellName.inviteFriendsCell.value) as? InviteFriendsCell else {
                return UITableViewCell()
            }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellName.followerCell.value) as? FollowerCell else {
                return UITableViewCell()
            }
            cell.configure(with: users[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let name = URL(string: FavoritConstant.shared.downloadUrl), !name.absoluteString.isEmpty {
                let objectsToShare = [name]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            }
        default:
            
            performSegue(withIdentifier: "searchToUserProfile", sender: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count - 1 && !isLoading {
            // Fetch more data when the last cell is about to be displayed
            searchUsers(searchTerm: searchController.searchBar.text ?? "")
        }
    }
}

extension FollowerCell {
    fileprivate func configure(with user: User) {
        
        userNameLabel.text = user.name
        followersCountLabel.text = "\(user.followers?.integer ?? 0)"
        favoritCountLabel.text = "\(user.following?.integer ?? 0)"
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
                                      options: [.transition(.fade(0.5)), .forceTransition]) { [weak userImageView] result in
                switch result {
                case .success: break
                case .failure:
                    userImageView?.setImage(string: user.name,
                                            color: UIColor.lightGray,
                                            circular: true,
                                            textAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .light),
                                                             NSAttributedString.Key.foregroundColor: UIColor.white])
                }
            }
        } else {
            userImageView.setImage(string: user.name,
                                   color: UIColor.lightGray,
                                   circular: true,
                                   textAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .light),
                                                    NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
}
