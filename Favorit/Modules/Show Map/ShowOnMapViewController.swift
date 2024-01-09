//
//  ShowOnMapViewController.swift
//  Favorit
//
//  Created by Amber Katyal on 03/12/23.
//

import UIKit
import MapKit

class ShowOnMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
//    var favoritVenue: FavoritVenue?
//    var savedVenue: SavedVenue?
//    var userVenues: [SavedVenue]?
    
    var place: Place?
    
    var isfromProfile = false
    
    let regionRadius: CLLocationDistance = 2000

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        setupMapPin()
        
        if isfromProfile {
            let backImage = UIImage(named: "blueBackIcon")?.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backToList))
            self.navigationItem.leftBarButtonItem  = backButton
            
            let listImage = UIImage(named: "list")?.withRenderingMode(.alwaysOriginal)
            let listButton = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(backToProfile))
            self.navigationItem.rightBarButtonItem  = listButton
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // We need to deselect all selected annotations here in order to prevent a MapKit-internal crash:
        for annotation in mapView.annotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    @objc func backToProfile() {
        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionFlipFromRight, animations: {
            self.navigationController?.popViewController(animated: true)
        }, completion: nil)
    }
    
    @objc func backToList() {
        guard let viewControllers = self.navigationController?.viewControllers else {return}
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    func setupMapPin() {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        if let place {
            addMapPin(venue: place, shouldCenter: true)
        }
        
//        if let venue = favoritVenue {
//            let savedVenue = SavedVenue(favoritVenue: venue, venueTip: nil, isFavorit: false)
//            addMapPin(venue: savedVenue, shouldCenter: true)
//        } else if let venue = savedVenue {
//            addMapPin(venue: venue, shouldCenter: true)
//        } else if let venues = userVenues {
//            for venue in venues {
//                addMapPin(venue: venue, shouldCenter: false)
//            }
//            mapView.showAnnotations(self.mapView.annotations, animated: true)
//        }
    }
    
    
    func addMapPin(venue: Place, shouldCenter: Bool){
        let venuePin = VenueMapPin(place: place)
        mapView.addAnnotation(venuePin)
        
        if shouldCenter {
            centerMapOnLocation(coordinate: venuePin.coordinate)
        }
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D)
    {
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "mapToPlaceDetails" {
//            guard let placeDetailsVC = segue.destination as? PlaceDetailViewController,
//                let pin = sender as? VenueMapPin,
//                let favVenue = pin.savedVenue else {return}
//            
//            if isfromProfile {
//                favVenue.venueTip = nil
//                favVenue.isFavorit = false
//            }
//            
//            placeDetailsVC.savedVenue = favVenue
        }
    }
}

extension ShowOnMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let cluster = annotation as? MKClusterAnnotation {
//            let identifier = "cluster"
//            let clusterView = VenueMapPinViews(annotation: annotation, reuseIdentifier: identifier)
//
//            let member = cluster.memberAnnotations.first as? VenueMapPin
//            let clusterType = member?.venueState
//            clusterView.markerTintColor = member?.markerTintColor
//
//            clusterView.displayPriority = .required
//
//            return clusterView
//        }
        
//        if let annotation = annotation as? VenueMapPin {
//            let identifier = "pin"
//            var view: VenueMapPinViews
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//                as? VenueMapPinViews {
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                print("else")
//                view = VenueMapPinViews(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                if isfromProfile {
//                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//                }
//            }
//            view.displayPriority = .required
//            
//            return view
//        }
        return nil
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if isfromProfile {
            performSegue(withIdentifier: "mapToPlaceDetails", sender: view.annotation)
        }
    }
}
