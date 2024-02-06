//
//  ShowOnMapViewController.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import UIKit
import MapKit

class ShowOnMapViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Properties
    var addressOnly: Place?
    var isfromProfile = false
    var bookmarkedVenues: [PlaceDetail]?
    
    private let regionRadius: CLLocationDistance = 2000
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initailSetting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // We need to deselect all selected annotations here in order to prevent a MapKit-internal crash:
        for annotation in mapView.annotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToPlaceDetails" {
            guard let pin = sender as? VenueMapPin,
                  let place = pin.place,
                  let placeDetailsVC = segue.destination as? PlaceDetailViewController else { return }

           placeDetailsVC.viewModel = PlaceDetailViewModel(place: place, placeID: place.placeId)
        }
    }
    
    //MARK: Private methods
    private func initailSetting() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.addNotificationObserver()
        self.setupMapPin()
        if isfromProfile {
            let backImage = UIImage(named: "blueBackIcon")?.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backToList))
            self.navigationItem.leftBarButtonItem  = backButton
            
            let listImage = UIImage(named: "list")?.withRenderingMode(.alwaysOriginal)
            let listButton = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(backToProfile))
            self.navigationItem.rightBarButtonItem  = listButton
        }
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshUserRecommendedPlaces(_:)),
                                               name: .refreshUserRecommendedPlaces, object: nil)
        
    }
    
    @objc func backToProfile() {
        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromRight, animations: {
            self.navigationController?.popViewController(animated: true)
        }, completion: nil)
    }
    
    @objc func backToList() {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @objc private func refreshUserRecommendedPlaces(_ notification: NSNotification) {
        guard let venues = notification.object as? [PlaceDetail] else {
            return
        }
        
        self.bookmarkedVenues = venues
        self.setupMapPin()
    }
    
    
    private func setupMapPin() {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        if let addressOnly {
            addMapPin(venue: addressOnly, shouldCenter: true)
        } else if let bookmarkedVenues {
            for bookmarkedVenue in bookmarkedVenues {
                if let venue = bookmarkedVenue.place {
                    self.addMapPin(venue: venue, shouldCenter: false)
                }
            }
        }
        
        mapView.showAnnotations(self.mapView.annotations,
                                animated: true)
    }
    
    
    private func addMapPin(venue: Place, 
                           shouldCenter: Bool){
        let venuePin = VenueMapPin(place: venue)
        mapView.addAnnotation(venuePin)
        
        if shouldCenter {
            centerMapOnLocation(coordinate: venuePin.coordinate)
        }
    }
    
    private func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

extension ShowOnMapViewController: MKMapViewDelegate {
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
                view = VenueMapPinViews(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                if isfromProfile {
                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                }
            }
            
            view.displayPriority = .required
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if isfromProfile {
            performSegue(withIdentifier: "mapToPlaceDetails", 
                         sender: view.annotation)
        }
    }
}
