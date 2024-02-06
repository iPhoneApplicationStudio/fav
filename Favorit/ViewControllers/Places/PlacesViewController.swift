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
    private let disptahcGroup = DispatchGroup()
    private var shouldRefreshScreenOnAppear = false
    
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
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldRefreshScreenOnAppear {
            self.shouldRefreshScreenOnAppear = false
            self.fetchData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFindPlaces" {
            guard let vc = segue.destination as? FindPlacesViewController else {
                return
            }
            
            let viewMode = FindPlacesViewModel(radius: FavoritConstant.defaultFrequency)
            vc.viewModel = viewMode
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Private methods
    private func initialSetting() {
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
    
    private func getMyBookmarks(shouldRefresh: Bool) {
        guard let viewModel else {
            return
        }
        
        guard (viewModel.allMyBookmarkedPlaces?.count ?? 0 <= 0) || shouldRefresh else {
            self.reloadScreen(dataCount: viewModel.allMyBookmarkedPlaces?.count ?? 0)
            return
        }
        
        self.activityIndicatorView.start()
        viewModel.getMyBookmarks {[weak self] result in
            self?.stopActivityIndicator()
            switch result {
            case .success(let flag):
                if !flag {
                    self?.showError(message: (viewModel.errorMessage))
                } else {
                    self?.reloadScreen(dataCount: viewModel.allMyBookmarkedPlaces?.count ?? 0)
                }
            case .failure(let error):
                self?.showError(message: (error.localizedDescription))
            }
        }
    }
        
    private func getRecommendedBookmarks(shouldRefresh: Bool) {
        guard let viewModel else {
            return
        }
        
        guard (viewModel.allRecommendedBookmarkedPlaces?.count ?? 0 <= 0) || shouldRefresh else {
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
    
    private func getAllBookmarks(shouldRefresh: Bool) {
        guard let viewModel else {
            return
        }
        
        guard (viewModel.allPlaces?.count ?? 0 <= 0) || shouldRefresh else {
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
            NotificationHelper.Post.refreshPlacesOnMap.fire()
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
            self.getMyBookmarks(shouldRefresh: shouldRefresh)
        case 1:
            filterMode = .recommendedPlaces
            self.getRecommendedBookmarks(shouldRefresh: shouldRefresh)
        case 2:
            filterMode = .allPlaces
            self.getAllBookmarks(shouldRefresh: shouldRefresh)
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
        
        mapViewController.mapDelegate = self
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
        self.getMyBookmarks(shouldRefresh: true)
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
            return viewModel.allMyBookmarkedPlaces?.count ?? 0
        case .recommendedPlaces:
            return viewModel.allRecommendedBookmarkedPlaces?.count ?? 0
        case .allPlaces:
            return viewModel.allPlaces?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return SavedCell.height
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
                                          for: filterMode)?.place
        if filterMode == .myPlaces {
            cell.configureStarImage()
        }
        
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
                        if viewModel.allMyBookmarkedPlaces?.count == 0 {
                            self?.showEmptyView()
                        }
                    } else {
                        self?.showError(message: viewModel.errorMessage)
                    }
                case .failure(let error):
                    self?.showError(message: error.localizedDescription)
                }
            }
            
            viewModel.removeBookmarkFor(index: index, handler: handler)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let viewModel,
              let placeDetail = viewModel.getItemFor(index: indexPath.row,
                                                        for: filterMode),
              let place = placeDetail.place,
              let detailController = PlaceDetailViewController.getViewController(viewModel: PlaceDetailViewModel(place: place, placeID: place.placeId))else {
            return
        }
        
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

extension PlacesViewController: MapViewControllerDelegate {
    func filterModeChanged(mode: PlaceType) {
        self.filterMode = mode
        self.segmentedFilterControl.selectedSegmentIndex = filterMode.rawValue
        self.shouldRefreshScreenOnAppear = true
    }
}

extension PlacesViewController {
    public static func createNavPlacesViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: StoryboardName.main.value,
                                      bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerName.favoritNavVC.value) as? UINavigationController
    }
}
