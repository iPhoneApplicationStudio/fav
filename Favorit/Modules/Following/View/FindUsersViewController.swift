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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var noSearchResultsLabel: UILabel!
    
    @Dependency private var viewModel: FollowingViewModel?
    private let searchController = UISearchController(searchResultsController: nil)
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = FavoritConstant.Colors.primaryColor
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
        getUsers()
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
    }

    
    @objc func refreshUsers() {
        searchController.isActive = false
        getUsers()
    }
    
    func getUsers(){
//        activityIndicatorView.isHidden = false
//        activityIndicatorView.startAnimating()
//        let services = UserServices()
//        services.getUsers { (users, error) in
//            if error == nil {
//                guard let initialUsers = users else {return}
//                self.users = initialUsers
//            } else {
//                self.showError(message: (error?.localizedDescription)!)
//            }
//            self.handleActivityIndicatorAnimations()
//            self.handleResultsUI()
//        }
    }
    
    func searchUsers(searchTerm: String) {
//        let services = UserServices()
//        services.searchUsers(searchTerm: searchTerm) { (users, error) in
//            if error == nil {
//                self.users.removeAll()
//                guard let searchResultUsers = users else {return}
//                self.users = searchResultUsers
//            } else {
//                self.showError(message: "Error \(error?.localizedDescription)")
//            }
//            
//            self.handleActivityIndicatorAnimations()
//            self.handleResultsUI()
//        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        //api call
        viewModel.getFollowers()
//        {[weak self] result in
//            self?.handleActivityIndicatorAnimations()
//            switch result {
//            case .success:
//                DispatchQueue.main.async {
//                    self?.handleResultsUI()
//                }
//            case .failure(let error):
//                self?.showError(message: (error.localizedDescription))
//            }
//        }
    }
    
    func handleResultsUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        if viewModel.numberOfUsers == 0 {
            self.noSearchResultsLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            if !self.noSearchResultsLabel.isHidden {
                self.noSearchResultsLabel.isHidden = true
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
            tableView.setContentOffset(CGPoint.zero, animated: true)
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
        guard let viewModel = viewModel else {
            return 0
        }
        
        switch section {
        case 0:
            return 1
        default:
            return viewModel.numberOfUsers
        }
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        
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
            
            _ = viewModel.userForIndex(indexPath.row)
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
            guard viewModel != nil else {
                return
            }
            
            performSegue(withIdentifier: "searchToUserProfile", sender: indexPath)
        }
    }
}
