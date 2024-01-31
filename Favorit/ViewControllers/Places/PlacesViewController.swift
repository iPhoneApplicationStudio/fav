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
    //MARK: IBOutlet
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var noSavedPlacesLabel: UILabel!
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var segmentedFilterControl: FavoritSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    private var filterMode: PlaceType = .myPlaces
    private var shouldRefresh = false
    private let locationService = LocationService.shared
    private let disptahcGroup = DispatchGroup()
    
    var viewModel: PlaceListProtocol?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(refreshMyVenues), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: Life cycle
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: 66,
                                                   right: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(refreshControl)
        
        let nib = UINib(nibName: SavedCell.identifier, bundle: nil)
        self.tableView.register(nib,
                                forCellReuseIdentifier: SavedCell.identifier)
        
        self.segmentedFilterControl.selectedSegmentIndex = filterMode.rawValue
        self.addNotificationObserver()
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshMyPlaces),
                                               name: .refreshMyPlaces, object: nil)
        
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
    
    private func getMyPlaces() {
        guard let viewModel else {
            return
        }
        
        disptahcGroup.enter()
        disptahcGroup.enter()
        self.activityIndicatorView.start()
        self.getMyBookmarks()
        self.getMyFavourites()
        disptahcGroup.notify(queue: .main) {
            self.stopActivityIndicator()
            self.reloadScreen(dataCount: viewModel.allMyPlacesCount)
        }
    }
    
    private func getMyBookmarks() {
        guard let viewModel else {
            return
        }
        
        viewModel.getMyBookmarks {[weak self] result in
            defer {
                self?.disptahcGroup.leave()
            }
            
            switch result {
            case .success(let flag):
                if !flag {
                    self?.showError(message: (viewModel.errorMessage))
                }
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
            }
        }
    }
    
    private func getMyFavourites() {
        guard let viewModel else {
            return
        }
        
        viewModel.getMyFavourites() {[weak self] result in
            defer {
                self?.disptahcGroup.leave()
            }
            
            switch result {
            case .success(let flag):
                if !flag {
                    self?.showError(message: (viewModel.errorMessage))
                }
                
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
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
        
        self.activityIndicatorView.start()
        viewModel.getAllRecommendedBookmarks {[weak self] result in
            self?.stopActivityIndicator()
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen(dataCount: viewModel.allRecommendedBookmarkedPlaces?.count ?? 0)
                } else {
                    self?.showError(message: viewModel.errorMessage)
                }
                
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
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
        self.shouldRefresh = false
        guard dataCount != 0 else {
            self.showEmptyView()
            return
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.noSavedPlacesLabel.isHidden = true
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
            self?.fadeInUI()
        }
    }
    
    private func showEmptyView() {
        DispatchQueue.main.async {[weak self] in
            self?.noSavedPlacesLabel.text = self?.getEmptyResultsStrings()
            self?.noSavedPlacesLabel.isHidden = false
            self?.tableView.isHidden = true
        }
    }
    
    private func fadeInUI(){
        UIView.animate(withDuration: 1.5, animations: {
            self.tableView.alpha = 1.0
            self.filterContainerView.alpha = 1.0
        })
    }
    
    private func stopActivityIndicator() {
        self.activityIndicatorView.stop()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK: IBAction
    @IBAction func fetchData() {
        switch segmentedFilterControl.selectedSegmentIndex {
        case 0:
            filterMode = .myPlaces
            self.getMyPlaces()
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
    
    @objc private func refreshMyPlaces() {
        self.getMyPlaces()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFindPlaces" {
            guard let vc = segue.destination as? FindPlacesViewController else {
                return
            }
            
            let viewMode = FindPlacesViewModel(radius: FavoritConstant.defaultFrequency)
            vc.viewModel = viewMode
        }
    }
}

extension PlacesViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel else {
            return 0
        }
        
        switch filterMode {
        case .myPlaces:
            return 2
        case .recommendedPlaces, .allPlaces:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else {
            return 0
        }
        
        switch filterMode {
        case .myPlaces:
            switch section {
            case 0:
                return viewModel.allMyFavouritePlaces?.count ?? 0
            case 1:
                return viewModel.allMyBookmarkedPlaces?.count ?? 0
            default:
                return 0
            }
            
        case .recommendedPlaces:
            return viewModel.allRecommendedBookmarkedPlaces?.count ?? 0
        case .allPlaces:
            return viewModel.allPlaces?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: SavedCell.identifier) as? SavedCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.starImageView.isHidden = true
        cell.place = viewModel.getItemFor(index: indexPath.row,
                                          for: filterMode,
                                          section: indexPath.section)?.place
        cell.section = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if filterMode == .myPlaces {
            return .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if filterMode == .myPlaces, editingStyle == .delete {
            guard let viewModel else {
                return
            }
            
            self.activityIndicatorView.start()
            let index = indexPath.row
            let handler: (Result<Bool, Error>) -> Void = {[weak self] result in
                self?.stopActivityIndicator()
                switch result {
                case .success(let flag):
                    if flag {
                        self?.tableView.deleteRows(at: [indexPath], with: .top)
                        if viewModel.allMyPlacesCount == 0 {
                            self?.showEmptyView()
                        }
                    } else {
                        self?.showError(message: viewModel.errorMessage)
                    }
                case .failure(let error):
                    self?.showError(message: error.localizedDescription)
                }
            }
            
            if indexPath.section == 0 {
                viewModel.removeFavouriteFor(index: index, handler: handler)
            } else {
                viewModel.removeBookmarkFor(index: index, handler: handler)
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let viewModel,
              let placeDetail = viewModel.getItemFor(index: indexPath.row,
                                                        for: filterMode,
                                                     section: indexPath.section),
              let place = placeDetail.place,
              let detailController = PlaceDetailViewController.getViewController(viewModel: PlaceDetailViewModel(place: place, placeID: place.placeId))else {
            return
        }
        
        self.navigationController?.pushViewController(detailController,
                                                      animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard viewModel != nil else {
            return nil
        }
        
        switch filterMode {
        case .myPlaces:
            switch section {
            case 0:
                return "Favorites"
            case 1:
                return "Bookmarks"
            default:
                return nil
            }
            
        case .recommendedPlaces, .allPlaces:
            return nil
        }
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

extension PlacesViewController {
    public static func createNavPlacesViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: StoryboardName.main.value,
                                      bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerName.favoritNavVC.value) as? UINavigationController
    }
}
