//
//  FindPlacesViewModel.swift
//  Favorit
//
//  Created by ONS on 08/12/23.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
import SideMenu

class FindPlacesViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var noSearchResultsLabel: UILabel!
    
    //MARK: Properties
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self,
                                 action: #selector(refreshVenues),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let locationService = LocationService.shared
    var viewModel: FindPlacesProtocol?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationService.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationService.delegate = nil
    }
    
    //MARK: Private methods
    private func initialSetting() {
        self.setupTableView()
        self.setupSearchController()
        self.activityIndicatorView.isHidden = false
        self.startActivityIndicator()
        if locationService.currentLocation != nil {
            self.getVenuePlaces()
        } else {
            self.locationService.startUpdatingLocation()
        }
    }
    
    private func setupSearchController() {
        self.searchController.searchBar.delegate = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = self.viewModel?.searchTitle
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    private func setupTableView() {
        self.tableView.addSubview(refreshControl)
        let nib = UINib(nibName: "VenueSearchResultCell",
                        bundle: nil)
        self.tableView.register(nib,
                                forCellReuseIdentifier: "searchCell")
    }
    
    private func getVenuePlaces(searchText: String? = nil) {
        guard let viewModel else {
            return
        }
        
        self.startActivityIndicator()
        viewModel.getAllPlacesFor(text: searchText ?? "") {[weak self] result in
            self?.manageActivityIndicatorFlow()
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen()
                } else {
                    if let errorMessage = viewModel.errorMessage {
                        self?.showError(message: (errorMessage))
                    }
                }
                
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
            case .none:
                break
            }
        }
    }
    
    private func startActivityIndicator() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicatorView.isHidden = false
            self?.activityIndicatorView.startAnimating()
        }
    }
    
    private func reloadScreen() {
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
                
                UIView.animate(withDuration: 1.5, animations: {
                    self?.tableView.alpha = 1.0
                })
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func manageActivityIndicatorFlow() {
        DispatchQueue.main.async {[weak self] in
            if self?.activityIndicatorView.isAnimating ?? false {
                self?.activityIndicatorView.isHidden = true
                self?.activityIndicatorView.stopAnimating()
            }
            
            if self?.refreshControl.isRefreshing ?? false {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func refreshVenues() {
        self.getVenuePlaces()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, 
                          sender: Any?) {
        if segue.identifier == "FilterPlaceSideMenu" {
            let navigationViewController = segue.destination as? SideMenuNavigationController
            if let rootVC = navigationViewController?.topViewController as? FilterPlacesViewController {
                rootVC.delegate = self
            }
            
        } else {
            guard let viewModel,
                  segue.identifier == "PlaceDetailViewController",
                  let detailController = segue.destination as? PlaceDetailViewController,
                  let indexPath = sender as? IndexPath,
                  let place = viewModel.itemForIndex(indexPath.row) else {
                return
            }
            
            let placeDetailViewModel = PlaceDetailViewModel(place: place,
                                                 placeID: place.placeId)
            detailController.viewModel = placeDetailViewModel
        }
    }
    
    func performToDetaisSegue(indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PlaceDetailViewController",
                     sender: indexPath)
    }
}

//MARK: UISearchBarDelegate
extension FindPlacesViewController: UISearchBarDelegate {
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
        //        searchBar.resignFirstResponder()
        if let searchTerm = searchBar.text {
            self.searchController.isActive = false
            self.getVenuePlaces(searchText: searchTerm)
        }
    }
}

//MARK: UITableViewDelegate-DataSource
extension FindPlacesViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, 
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as? VenueSearchResultCell else {
            return UITableViewCell()
        }
        
        let place = viewModel.itemForIndex(indexPath.row)
        cell.place = place
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.performToDetaisSegue(indexPath: indexPath)
            }
            
        } else {
            self.performToDetaisSegue(indexPath: indexPath)
        }
    }
}

//MARK: LocationServiceDelegate
extension FindPlacesViewController: LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        self.getVenuePlaces()
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        
    }
}

extension FindPlacesViewController: FilterPlacesViewControllerDelegate {
    func didChangeRadiusFrequencyAndCategories(frequency: RadiusFrequency,
                                               categoties: [String]) {
        self.viewModel?.radius = frequency
        self.getVenuePlaces()
    }
}
