//
//  FindUsersViewController.swift
//  Favorit
//
//  Created by ONS on 12/19/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FindUsersViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var noSearchResultsLabel: UILabel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private var isLoading = false
    
    var viewModel: FindUsersProtocol?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, 
                                 action: #selector(refreshUsers),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    private func initialSetting() {
        self.title = viewModel?.pageTitle
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        self.tableView.addSubview(refreshControl)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.tableFooterView = loadingIndicator
        self.tableView.isHidden = true
        
        self.searchController.searchBar.delegate = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = viewModel?.searchTitle
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.becomeFirstResponder()
        
        self.noSearchResultsLabel.isHidden = false
        self.loadingIndicator.hidesWhenStopped = true
    }
    
    @objc func refreshUsers() {
        guard let viewModel else {
            return
        }
        
        viewModel.currentPage = 1
        self.isLoading = false
        searchController.isActive = false
        searchUsers(searchTerm: searchController.searchBar.text ?? "")
    }
    
    private func searchUsers(searchTerm: String) {
        guard let viewModel, !isLoading else {
            return
        }
        
        isLoading = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        if viewModel.currentPage > 1 {
            loadingIndicator.startAnimating()
        }
        
        viewModel.searchUser(text: searchTerm) {[weak self] result in
            self?.loadingIndicator.stopAnimating()
            self?.activityIndicatorView.isHidden = true
            self?.activityIndicatorView.stopAnimating()
            self?.isLoading = false
            
            guard let result else {
                return
            }
            
            switch result {
            case .success(let status):
                if status {
                    self?.handleResultsUI()
                }
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
                self?.isLoading = false
            }
            
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func handleResultsUI() {
        guard let viewModel else {
            return
        }
        
        DispatchQueue.main.async {[weak self] in
            if viewModel.numberOfItems == 0 {
                self?.noSearchResultsLabel.isHidden = false
                self?.tableView.isHidden = true
            } else {
                self?.noSearchResultsLabel.isHidden = true
                self?.tableView.isHidden = false
            }
            
            self?.tableView.reloadData()
        }
    }
}

extension FindUsersViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSection ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return viewModel?.numberOfItems ?? 0
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
            
            let user = viewModel?.getItemFor(index: indexPath.row)
            cell.configure(with: user)
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
            guard let viewModel,
                  let userId = viewModel.getItemFor(index: indexPath.row)?._id,
                  let vc = UIStoryboard(name: StoryboardName.main.value,
                                        bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.userDetail.value) as? UserDetailsViewController else {
                return
            }
            
            let userDetailViewModel = UserDetailViewModel(userID: userId,
                                                          isEditMode: false)
            vc.viewModel = userDetailViewModel
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, 
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let viewModel else {
            return
        }
        let usersCount = viewModel.numberOfItems
        let total = viewModel.totalUsers
        
        guard indexPath.row == usersCount - 1,
              !isLoading,
              usersCount < total else {
            return
        }
        
        self.searchUsers(searchTerm: searchController.searchBar.text ?? "")
    }
}

extension FindUsersViewController: UISearchBarDelegate {
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
        guard let viewModel, let text = searchBar.text else {
            return
        }
        
        viewModel.currentPage = 1
        self.isLoading = false
        self.searchUsers(searchTerm: text)
    }
}
