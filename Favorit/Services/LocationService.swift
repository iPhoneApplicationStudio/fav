//
//  Location Service.swift
//  Favorit
//
//  Created by Chris Piazza on 11/13/17.
//  Copyright © 2017 Bushman Studio. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: Error)
}

class LocationService: NSObject {
    static let shared = LocationService()
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var centerMapLocation: CLLocation?
    weak var delegate: LocationServiceDelegate?
    
    override private init() {
        super.init()
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        guard let locationManager else {
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationServicesCheck(handler: @escaping (Bool?, String?) -> Void) {
        guard let locationManager else {
            handler(nil, nil)
            return
        }
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch locationManager.authorizationStatus {
                case .restricted, .denied:
                    handler(false, "Please allow the location permission from setting app.")
                case .authorizedAlways, .authorizedWhenInUse:
                    handler(true, nil)
                case .notDetermined:
                    handler(nil, nil)
                @unknown default:
                    handler(nil, nil)
                }
            } else {
                handler(nil, nil)
            }
        }
    }
    
    func requestOneTimeLocation() {
        print("One time location updates")
        self.locationManager?.requestLocation()
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    private func updateLocation(currentLocation: CLLocation){
        self.delegate?.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        self.delegate?.tracingLocationDidFailWithError(error: error)
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, 
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.currentLocation = location
        self.centerMapLocation = location
        
        // use for real time update location
        self.updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // do on error
        self.updateLocationDidFailWithError(error: error)
    }
}
