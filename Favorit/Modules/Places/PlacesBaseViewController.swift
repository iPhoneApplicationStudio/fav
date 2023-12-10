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

enum FilterMode:Int {
    case myPlaces = 0
    case followed = 1
    case all = 2
}

class PlacesBaseViewController: UIViewController {
    
    enum PlacesVCState:String {
        case list
        case map
    }
    
    @IBOutlet weak var noSavedPlacesLabel: UILabel!
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var segmentedFilterControl: FavoritSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
//    var bookmarkedVenues = [SavedVenue]()
//    var favoritVenues = [SavedVenue]()
//    
    var filterMode: FilterMode = .myPlaces
    var placesVCState: PlacesVCState = .list
    var shouldRefresh = false
    
    private let regionRadius: CLLocationDistance = 2000
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(refreshMyVenues), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotificationisteners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldRefresh {
            handleFilterData()
            shouldRefresh = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: Setup UI
extension PlacesBaseViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 66,
                                              right: 0)
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        
        let nib = UINib(nibName: "SavedCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "savedCell")
    }
    
    func setupMap() {
        placesVCState = .map
//        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 5.0
        mapView.clipsToBounds = true
        
        segmentedFilterControl.selectedSegmentIndex = filterMode.rawValue
        
        setupMapPins()
    }
    
    //MARK: Location Services
    func setLocationServices() {
//        guard let isLocationAuthorized = LocationService.sharedInstance.locationServicesCheck() else {
//            LocationService.sharedInstance.startUpdatingLocation()
//            return
//        }
//        if isLocationAuthorized {
//            LocationService.sharedInstance.startUpdatingLocation()
//        } else {
//            handleFilterData()
//        }
    }
}

private extension PlacesBaseViewController {
    //MARK: Common UI Setup
    func fadeInUI(){
        UIView.animate(withDuration: 1.5, animations: {
            self.tableView.alpha = 1.0
            self.filterContainerView.alpha = 1.0
        })
    }
    
    func handleVCStateUI() {
        switch placesVCState {
        case .list:
            handleResultsUI()
            fadeInUI()
        case .map:
            setupMapPins()
        }
    }
    
    func handleResultsUI() {
        if placesVCState == .list {
            setUpListUIState()
        }
    }
    
    func setUpListUIState() {
//        if self.favoritVenues.count == 0
//            && self.bookmarkedVenues.count == 0 {
//            handleEmptyResults()
//        } else {
//            handleSavedVenuesResults()
//        }
    }
    
    func handleEmptyResults() {
        self.noSavedPlacesLabel.text = getEmptyResultsStrings()
        self.noSavedPlacesLabel.isHidden = false
        self.tableView.isHidden = true
    }
    
    func handleSavedVenuesResults() {
        if !self.noSavedPlacesLabel.isHidden {
            self.noSavedPlacesLabel.isHidden = true
            self.tableView.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    func handleActivityIndicatorAnimations() {
        if activityIndicatorView.isAnimating {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        }
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: Venue Management
    @objc func refreshMyVenues() {
        if !shouldRefresh {
            shouldRefresh = true
        }
    }
    
    @objc func userAuthChanged() {
        handleFilterData()
    }
    
    func getMyVenues() {
//        handleActivityIndicatorAnimations()
//        guard let userObjectId = FavoritUser.current()?.objectId else {
//            self.handleActivityIndicatorAnimations()
//            self.handleResultsUI()
//            return
//        }
//        let params: [String:String] = [
//            "userObjectId" : userObjectId]
//        let services = VenueServices()
//        services.getCurrentUserVenues(params: params) { (favorits, bookmarked, error) in
//            if error == nil {
//                if self.favoritVenues.count > 0 {
//                    self.favoritVenues.removeAll()
//                }
//                if let favoritsVenues = favorits, favoritsVenues.count > 0 {
//                    self.favoritVenues = DistanceHelper.addDistanceFromUserAndSort(venueArray: favoritsVenues)
//                }
//                
//                if self.bookmarkedVenues.count > 0 {
//                    self.bookmarkedVenues.removeAll()
//                }
//                
//                if let bookmarkedVenues = bookmarked, bookmarkedVenues.count > 0 {
//                    self.bookmarkedVenues = DistanceHelper.addDistanceFromUserAndSort(venueArray: bookmarkedVenues)
//                }
//                
//                self.handleActivityIndicatorAnimations()
//                self.handleVCStateUI()
//                
//            } else {
//                guard let err = error else {
//                    self.showError(message: "There was an error")
//                    return
//                }
//                self.showError(message: err.localizedDescription)
//                print(err)
//                self.handleActivityIndicatorAnimations()
//            }
//        }
    }
    
    func getAllUserFollowedVenues() {
//        handleActivityIndicatorAnimations()
//        let services = VenueServices()
//        services.getFollowingUsersSavedVenues() { (bookmarked, error) in
//            if error == nil {
//                self.bookmarkedVenues.append(contentsOf: self.favoritVenues)
//                let myVenues = self.bookmarkedVenues
//                if self.favoritVenues.count > 0 {
//                    self.favoritVenues.removeAll()
//                }
//                if self.bookmarkedVenues.count > 0 {
//                    self.bookmarkedVenues.removeAll()
//                }
//                
//                if var followersVenues = bookmarked, followersVenues.count > 0 {
//                    followersVenues.append(contentsOf: myVenues)
//                    let uniqueOrderedVenues = followersVenues.unique{$0.venueId}
//                    self.bookmarkedVenues = DistanceHelper.addDistanceFromUserAndSort(venueArray: uniqueOrderedVenues)
//                }
//                
//                self.handleActivityIndicatorAnimations()
//                self.handleVCStateUI()
//                
//            } else {
//                self.showError(message: (error?.localizedDescription)!)
//                print(error!)
//                self.handleActivityIndicatorAnimations()
//            }
//        }
//        
    }
    
    func getAllSavedVenues() {
//        handleActivityIndicatorAnimations()
//        let services = VenueServices()
//        services.getFavoritVenuesByLocation() { (bookmarked, error) in
//            if error == nil {
//                if self.favoritVenues.count > 0 {
//                    self.favoritVenues.removeAll()
//                }
//                if self.bookmarkedVenues.count > 0 {
//                    self.bookmarkedVenues.removeAll()
//                }
//                
//                if let allVenues = bookmarked, allVenues.count > 0 {
//                    self.bookmarkedVenues = DistanceHelper.addDistanceFromUserAndSort(venueArray: allVenues)
//                }
//                
//                self.handleActivityIndicatorAnimations()
//                self.handleVCStateUI()
//            } else {
//                self.showError(message: (error?.localizedDescription)!)
//                print(error!)
//                self.handleActivityIndicatorAnimations()
//            }
//        }
        
    }
    
    //MARK: Filter Control
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedFilterControl.selectedSegmentIndex
        {
        case 0:
            filterMode = FilterMode.myPlaces
        case 1:
            filterMode = FilterMode.followed
        case 2:
            filterMode = FilterMode.all
        default:
            break
        }
        handleFilterData()
    }
    
    func handleFilterData(){
//        if isLoggedIn() {
//            getVenueData()
//        } else {
//            resetVenuesArray()
//            handleResultsUI()
//        }
    }
    
    func resetVenuesArray() {
//        if self.favoritVenues.count > 0 {
//            self.favoritVenues.removeAll()
//        }
//        if self.bookmarkedVenues.count > 0 {
//            self.bookmarkedVenues.removeAll()
//        }
//        resetMainUIComponents()
    }
    
    func resetMainUIComponents() {
        switch placesVCState {
        case .list:
            self.tableView.reloadData()
        case .map:
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
    }
    
    func getVenueData() {
        switch filterMode {
        case FilterMode.myPlaces:
            print("My Places")
            getMyVenues()
            segmentedFilterControl.selectedSegmentIndex = 0
            filterMode = FilterMode.myPlaces
        case FilterMode.followed:
            print("Followed")
            getAllUserFollowedVenues()
            segmentedFilterControl.selectedSegmentIndex = 1
            filterMode = FilterMode.followed
        case FilterMode.all:
            print("All")
            getAllSavedVenues()
            segmentedFilterControl.selectedSegmentIndex = 2
            filterMode = FilterMode.all
        }
    }
    //MARK: NotificationCenter
    func setNotificationisteners() {
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshMyVenues), name: NSNotification.Name(rawValue: Constants.NotificationKeys.reloadMyPlaces), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(userAuthChanged),
//                                               name: NSNotification.Name(rawValue: Constants.NotificationKeys.userSignOutNotification),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(userAuthChanged),
//                                               name: NSNotification.Name(rawValue: Constants.NotificationKeys.userSignInNotification),
//                                               object: nil)
    }
}

//MARK: Map Setup
private extension PlacesBaseViewController {
    func setupMapPins() {
//        if mapView.annotations.count > 0 {
//            mapView.removeAnnotations(mapView.annotations)
//        }
//        
//        addMapPins(venues: favoritVenues)
//        addMapPins(venues: bookmarkedVenues)
//        
//        guard let currentLocation = LocationService.sharedInstance.currentLocation else {
//            mapView.showAnnotations(self.mapView.annotations, animated: true)
//            return
//        }
//        
//        centerMapOnLocation(location: currentLocation)
        
    }
    
    
//    func addMapPins(venues: [SavedVenue]){
////        for venue in venues {
////            let venuePin = VenueMapPin(savedVenue: venue)
////            mapView.addAnnotation(venuePin)
////        }
//    }
    
    func centerMapOnLocation(location: CLLocation)
    {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                  regionRadius * 2.0, regionRadius * 2.0)
//        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: To Map Button
    @IBAction func toMapButtonPressed(_ sender: Any) {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let mapViewController = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromLeft, animations: {
//            mapViewController.filterMode = self.filterMode
//            mapViewController.favoritVenues = self.favoritVenues
//            mapViewController.bookmarkedVenues = self.bookmarkedVenues
//            mapViewController.mapDelegate = self
//            self.navigationController?.pushViewController(mapViewController, animated: false)
//        }, completion: nil)
    }
    
    
}

extension PlacesBaseViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
//        switch section {
//        case 0:
//            return favoritVenues.count
//        default:
//            return bookmarkedVenues.count
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
//        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell") as! SavedCell
//        cell.selectionStyle = .none
//        switch indexPath.section {
//        case 0:
//            print("cell for row")
//            cell.savedVenue = getFavoritedVenue(indexPath: indexPath)
//            cell.starImageView.isHidden = false
//        default:
//            cell.savedVenue = getBookmarkedVenue(indexPath: indexPath)
//        }
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: indexPath)
    }
}

/*extension PlacesBaseViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let cluster = annotation as? MKClusterAnnotation {
            let identifier = "cluster"
            let clusterView = VenueMapPinViews(annotation: annotation, reuseIdentifier: identifier)
            
            let member = cluster.memberAnnotations.first as? VenueMapPin
            let clusterType = member?.venueState
            clusterView.markerTintColor = member?.markerTintColor
            
            clusterView.displayPriority = .required
            
            return clusterView
        }
        
        if let annotation = annotation as? VenueMapPin {
            let identifier = "pin"
            var view: VenueMapPinViews
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? VenueMapPinViews {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = VenueMapPinViews(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            view.displayPriority = .required
            
            return view
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "mapToPlaceDetails", sender: view.annotation)
    }
}

//MARK: Custom Delegates
extension PlacesBaseViewController: MapViewControllerDelegate, LocationServiceDelegate {
    // MARK: MapViewControllerDelegate
    func passFilterState(passedFilterMode: FilterMode) {
        filterMode = passedFilterMode
        handleFilterData()
    }
    // MARK: LocationService Delegate
    func tracingLocation(currentLocation: CLLocation) {
        LocationService.sharedInstance.stopUpdatingLocation()
        LocationService.sharedInstance.centerMapLocation = currentLocation
        handleFilterData()
    }
    
    func tracingLocationDidFailWithError(error: Error) {
        print("tracing Location Error : \(error)")
        handleFilterData()
    }
    
}*/


// MARK: Helper Methods
extension PlacesBaseViewController {
    func getEmptyResultsStrings() -> String {
//        switch filterMode {
//        case .myPlaces:
//            return  PlacesEmptyResultsStrings.myPlacesEmpty
//        case .followed:
//            return PlacesEmptyResultsStrings.followersEmpty
//        case .all:
//            return PlacesEmptyResultsStrings.worldEmpty
//        }
        return ""
    }
    
//    func getFavoritedVenue(indexPath: IndexPath) -> SavedVenue {
//        let selectedVenue = favoritVenues[indexPath.row]
//        return selectedVenue
//    }
//    
//    func getBookmarkedVenue(indexPath: IndexPath) -> SavedVenue {
//        let selectedVenue = bookmarkedVenues[indexPath.row]
//        return selectedVenue
//    }
}


