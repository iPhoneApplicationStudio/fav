//
//  MapViewController.swift
//  Favorit
//

import UIKit
import MapKit
import NVActivityIndicatorView

protocol MapViewControllerDelegate: AnyObject {
    func filterModeChanged(mode: PlaceType)
}

class MapViewController: UIViewController {    
    //MARK: IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var segmentedFilterControl: FavoritSegmentedControl!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //MARK: Properties
    private let locationService = LocationService.shared
    private let regionRadius: CLLocationDistance = 2000
    private var mapViewRegion: MKCoordinateRegion?
    
    weak var mapDelegate: MapViewControllerDelegate?
    weak var viewModel: PlaceListProtocol?
    var filterMode: PlaceType = .myPlaces
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationService.delegate = self
        self.reloadScreen()//TODO add closure to refresh screen
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mapDelegate?.filterModeChanged(mode: filterMode)
        locationService.delegate = nil
        NotificationCenter.default.removeObserver(self)
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
    
    
    //MARK: Private Methods
    private func initialSetting() {
        self.mapView.delegate = self
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
        self.addNotificationObserver()
        
        if locationService.currentLocation == nil {
            self.locationService.startUpdatingLocation()
        } 
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshPlacesOnMap),
                                               name: .refreshPlacesOnMap, object: nil)
        
    }
    
    private func getMyBookmarks() {
        guard let viewModel else {
            return
        }
        
        guard viewModel.allMyBookmarkedPlaces?.count ?? 0 <= 0 else {
            self.reloadScreen(details: viewModel.allMyBookmarkedPlaces)
            return
        }
        
        self.handleActivityIndicatorAnimations()
        viewModel.getMyBookmarks {[weak self] result in
            self?.handleActivityIndicatorAnimations()
            switch result {
            case .success(let flag):
                if flag {
                    self?.reloadScreen(details: viewModel.allMyBookmarkedPlaces)
                } else {
                    self?.showError(message: viewModel.errorMessage)
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
            self.reloadScreen(details: viewModel.allPlaces)
            return
        }
    }
    
    private func reloadScreen() {
        switch filterMode {
        case .myPlaces:
            self.reloadScreen(details: viewModel?.allMyBookmarkedPlaces)
        case .recommendedPlaces:
            self.reloadScreen(details: viewModel?.allRecommendedBookmarkedPlaces)
        case .allPlaces:
            self.reloadScreen(details: viewModel?.allPlaces)
        }
        
    }
    
    private func reloadScreen(details: [PlaceDetail]?) {
        guard let details,
              details.count > 0 else {
            return
        }
        
        if self.mapView.annotations.count > 0 {
            self.mapView.removeAnnotations(mapView.annotations)
        }
        
        self.addMapPins(details: details)
        guard let currentLocation = LocationService.shared.currentLocation else {
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            return
        }
        
        if let mapViewRegion = self.mapViewRegion {
            mapView.setRegion(mapViewRegion, animated: true)
        } else {
            let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate,
                                                      latitudinalMeters: regionRadius * 2.0,
                                                      longitudinalMeters: regionRadius * 2.0)
            self.mapViewRegion = coordinateRegion
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    
    private func addMapPins(details: [PlaceDetail]){
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
        switch segmentedFilterControl.selectedSegmentIndex {
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
    
    @objc private func refreshPlacesOnMap() {
        self.reloadScreen()
    }
}

//MARK: Map Setup
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let cluster = annotation as? MKClusterAnnotation {
            let identifier = "cluster"
            let clusterView = VenueMapPinViews(annotation: annotation, 
                                               reuseIdentifier: identifier)
            let member = cluster.memberAnnotations.first as? VenueMapPin
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
                view = VenueMapPinViews(annotation: annotation, 
                                        reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            
            view.displayPriority = .required
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, 
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let pin = view.annotation as? VenueMapPin,
              let place = pin.place else {
            return
        }
        
        guard let detailController = PlaceDetailViewController.getViewController(viewModel: PlaceDetailViewModel(
            place: place,
            placeID: place.placeId))else {
            return
        }
        
        self.mapViewRegion = mapView.region
        self.navigationController?.pushViewController(detailController,
                                                      animated: true)
    }
}

//MARK: Custom Delegates
//extension PlacesBaseViewController: MapViewControllerDelegate {
//    // MARK: MapViewControllerDelegate
//    func passFilterState(passedFilterMode: FilterMode) {
//        filterMode = passedFilterMode
//        handleFilterData()
//    }
//}*/

extension MapViewController: LocationServiceDelegate {
    func tracingLocationDidFailWithError(error: Error) { }
    
    func tracingLocation(currentLocation: CLLocation) {
        self.reloadScreen()
    }
}
