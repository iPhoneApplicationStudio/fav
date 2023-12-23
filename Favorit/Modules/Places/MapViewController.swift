//
//  MapViewController.swift
//  Favorit
//
//  Created by Chris Piazza on 11/10/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class MapViewController: UIViewController {    
    //MARK: IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var segmentedFilterControl: FavoritSegmentedControl!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    private let locationService = LocationService.sharedInstance
    private let regionRadius: CLLocationDistance = 2000
    
    weak var viewModel: PlaceListProtocol?
    var filterMode: PlaceType = .myPlaces
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.mapDelegate?.passFilterState(filterMode: filterMode)
    }
    
    //MARK: Private Methods
    private func initialSetting() {
        //self.mapView.delegate = self //Todo
        self.mapView.showsUserLocation = true
        self.mapView.layer.cornerRadius = 5.0
        self.mapView.clipsToBounds = true
        self.segmentedFilterControl.selectedSegmentIndex = filterMode.rawValue
        
        let image = UIImage(named: "list")?.withRenderingMode(.alwaysOriginal)
        let listButton = UIBarButtonItem(image: image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backToList))
        self.navigationItem.leftBarButtonItem  = listButton
        
        switch filterMode {
        case .myPlaces:
            self.reloadScreen(details: viewModel?.allMyPlaces)
        case .recommendedPlaces:
            self.reloadScreen(details: viewModel?.allRecommendedBookmarkedPlaces)
        case .allPlaces:
            self.reloadScreen(details: viewModel?.allPlaces)
        }
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
    
    
    private func getMyBookmarks() {
        guard let viewModel else {
            return
        }
        
        guard viewModel.allMyPlaces?.count ?? 0 <= 0 else {
            self.reloadScreen(details: viewModel.allMyPlaces)
            return
        }
        
        self.handleActivityIndicatorAnimations()
        viewModel.getMyBookmarks {[weak self] result in
            self?.handleActivityIndicatorAnimations()
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen(details: viewModel.allMyPlaces)
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
        
        guard viewModel.allRecommendedBookmarkedPlaces?.count ?? 0 > 0 else {
            self.reloadScreen(details: viewModel.allRecommendedBookmarkedPlaces)
            return
        }
        
        self.handleActivityIndicatorAnimations()
        viewModel.getAllRecommendedBookmarks {[weak self] result in
            self?.handleActivityIndicatorAnimations()
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen(details: viewModel.allRecommendedBookmarkedPlaces)
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
        
        guard viewModel.allPlaces?.count ?? 0 > 0 else {
            self.reloadScreen(details: viewModel.allPlaces)
            return
        }
    }
    
    private func reloadScreen(details: [BookmarkDetail]?) {
        guard let details,
              details.count > 0 else {
            return
        }
        
        if self.mapView.annotations.count > 0 {
            self.mapView.removeAnnotations(mapView.annotations)
        }
        
        self.addMapPins(details: details)
        guard let currentLocation = LocationService.sharedInstance.currentLocation else {
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            return
        }
        
        let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    private func addMapPins(details: [BookmarkDetail]){
        for detail in details {
            let venuePin = VenueMapPin(place: detail.place)
            self.mapView.addAnnotation(venuePin)
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
        }
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
    
    @objc func backToList() {
        guard let view = self.navigationController?.view else {
            return
        }
        
        UIView.transition(with: view,
                          duration: 1.0,
                          options: .transitionFlipFromRight,
                          animations: {
            self.navigationController?.popViewController(animated: true)
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "mapToPlaceDetails" {
//            let pin = sender as! VenueMapPin
//            let placeDetailsVC = segue.destination as! PlaceDetailViewController
//            placeDetailsVC.savedVenue = pin.savedVenue
//        }
//
//        if segue.identifier == "mapToFindVenues" {
//            let findVC = segue.destination as! FindPlacesViewController
//        }
    }
}

//MARK: Map Setup
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
//extension PlacesBaseViewController: MapViewControllerDelegate, LocationServiceDelegate {
//    // MARK: MapViewControllerDelegate
//    func passFilterState(passedFilterMode: FilterMode) {
//        filterMode = passedFilterMode
//        handleFilterData()
//    }
//    // MARK: LocationService Delegate
//    func tracingLocation(currentLocation: CLLocation) {
//        LocationService.sharedInstance.stopUpdatingLocation()
//        LocationService.sharedInstance.centerMapLocation = currentLocation
//        handleFilterData()
//    }
//    
//    func tracingLocationDidFailWithError(error: Error) {
//        print("tracing Location Error : \(error)")
//        handleFilterData()
//    }
//    
//}*/
