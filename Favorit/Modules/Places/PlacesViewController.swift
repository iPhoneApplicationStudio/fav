//
//  PlacesBaseViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 4/9/20.
//  Copyright © 2020 Bushman Studio. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class PlacesViewController: UIViewController {
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var noSavedPlacesLabel: UILabel!
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var segmentedFilterControl: FavoritSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    private var filterMode: PlaceType = .myPlaces
    private var shouldRefresh = false
    private let locationService = LocationService.sharedInstance
    
    var viewModel: PlaceListProtocol?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(refreshMyVenues), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
//        self.checkLocationService()
        self.fetchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Private methods
    private func initialSetting() {
        self.locationService.delegate = self
        //Set table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 66,
                                              right: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(refreshControl)
        
        let nib = UINib(nibName: "SavedCell", bundle: nil)
        self.tableView.register(nib,
                                forCellReuseIdentifier: "savedCell")
        
        self.segmentedFilterControl.selectedSegmentIndex = filterMode.rawValue
    }
    
    private func checkLocationService() {
        guard let _ = viewModel else {
            return
        }
        
        self.locationService.locationServicesCheck {[unowned self] flag, message in
            guard let flag else {
                self.locationService.requestAuthorization()
                return
            }
            
            if flag == false,
               let _ = message {
                self.openSettingApplication()
            } else if flag == true {
                self.locationService.requestOneTimeLocation()
            }
        }
    }
    
    private func handleActivityIndicatorAnimations() {
        DispatchQueue.main.async {[weak self] in
            if self?.activityIndicatorView.isAnimating ?? true {
                self?.activityIndicatorView.isHidden = true
                self?.activityIndicatorView.stopAnimating()
            } else {
                self?.activityIndicatorView.isHidden = false
                self?.activityIndicatorView.startAnimating()
            }
            
            if self?.refreshControl.isRefreshing ?? true {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func getMyBookmarks() {
        guard let viewModel else {
            return
        }
        
//        guard !self.shouldRefresh, viewModel.allMyPlaces?.count ?? 0 <= 0 else {
//            self.reloadScreen(dataCount: viewModel.allMyPlaces?.count ?? 0)
//            return
//        }
        
        self.handleActivityIndicatorAnimations()
        viewModel.getMyBookmarks {[weak self] result in
            self?.handleActivityIndicatorAnimations()
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen(dataCount: viewModel.allMyPlaces?.count ?? 0)
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
    
    private func getRecommendedBookmarks() {
        guard let viewModel else {
            return
        }
        
        guard viewModel.allRecommendedBookmarkedPlaces?.count ?? 0 <= 0 else {
            self.reloadScreen(dataCount: viewModel.allRecommendedBookmarkedPlaces?.count ?? 0)
            return
        }
        
        self.handleActivityIndicatorAnimations()
        viewModel.getAllRecommendedBookmarks {[weak self] result in
            self?.handleActivityIndicatorAnimations()
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen(dataCount: viewModel.allRecommendedBookmarkedPlaces?.count ?? 0)
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
    
    private func getAllBookmarks() {
        guard let viewModel else {
            return
        }
        
        guard viewModel.allPlaces?.count ?? 0 <= 0 else {
            self.reloadScreen(dataCount: viewModel.allPlaces?.count ?? 0)
            return
        }
    }
    
    private func reloadScreen(dataCount: Int) {
        DispatchQueue.main.async {[weak self] in
            if dataCount == 0 {
                self?.noSavedPlacesLabel.text = self?.getEmptyResultsStrings()
                self?.noSavedPlacesLabel.isHidden = false
                self?.tableView.isHidden = true
            } else {
                self?.noSavedPlacesLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                self?.fadeInUI()
            }
            
            self?.shouldRefresh = false
        }
    }
    
    private func fadeInUI(){
        UIView.animate(withDuration: 1.5, animations: {
            self.tableView.alpha = 1.0
            self.filterContainerView.alpha = 1.0
        })
    }
    
    //MARK: IBAction
    @IBAction func fetchData() {
        switch segmentedFilterControl.selectedSegmentIndex
        {
        case 0:
            filterMode = .myPlaces
            self.getMyBookmarks()
        case 1:
            filterMode = .recommendedPlaces
            self.getRecommendedBookmarks()
        case 2:
            filterMode = .allPlaces
            self.getAllBookmarks()
        default:
            break
        }
    }
    
    @IBAction func toMapButtonPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: StoryboardName.main.value,
                                          bundle: nil)
        guard let mapViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerName.mapVC.value) as? MapViewController,
              let view = self.navigationController?.view else {
            return
        }
        
        UIView.transition(with: view,
                          duration: 1.0,
                          options: .transitionFlipFromLeft,
                          animations: {
            mapViewController.filterMode = self.filterMode
            mapViewController.viewModel = self.viewModel
            self.navigationController?.pushViewController(mapViewController, animated: false)
        }, completion: nil)
    }
    
    @objc func refreshMyVenues() {
        if !self.shouldRefresh {
            self.shouldRefresh = true
            self.fetchData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFindPlaces" {
            guard let vc = segue.destination as? FindPlacesViewController else {
                return
            }
            
            let viewMode = FindPlacesViewModel()
            vc.viewModel = viewMode
        }
    }
}

extension PlacesViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else {
            return 0
        }
        
        switch filterMode {
        case .myPlaces:
            return viewModel.allMyPlaces?.count ?? 0
        case .recommendedPlaces:
            return viewModel.allRecommendedBookmarkedPlaces?.count ?? 0
        case .allPlaces:
            return viewModel.allPlaces?.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, 
                   estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell") as? SavedCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.starImageView.isHidden = true
        cell.place = viewModel.getItemFor(index: indexPath.row,
                                          for: filterMode)?.place
        return cell
    }
    
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        guard let viewModel,
              let detailController = PlaceDetailViewController.createPlaceDetailViewController(),
              let bookmarkDetail = viewModel.getItemFor(index: indexPath.row,
                                                        for: filterMode),
              let place = bookmarkDetail.place else {
            return
        }
        
        let placeDetailViewModel = PlaceDetailViewModel(place: place,
                                                        placeID: place.placeId)
        detailController.viewModel = placeDetailViewModel
        self.navigationController?.pushViewController(detailController,
                                                      animated: true)
    }
}

// MARK: Helper Methods
extension PlacesViewController {
    func getEmptyResultsStrings() -> String {
        switch filterMode {
        case .myPlaces:
            return  PlacesEmptyResultsStrings.myPlacesEmpty
        case .recommendedPlaces:
            return PlacesEmptyResultsStrings.followersEmpty
        case .allPlaces:
            return PlacesEmptyResultsStrings.worldEmpty
        }
    }
}

//MARK: LocationServiceDelegate
extension PlacesViewController: LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        self.locationService.stopUpdatingLocation()
       //self.handleFilterData
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        
    }
}
