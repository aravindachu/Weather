//
//  LocationManager.swift
//  Weather
//
//  Created by Aravind Vijayan on 01/03/22.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    var latestCordinates: ((_ lat: Double, _ long: Double) -> Void)?

    func requestLocationAuthorization() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        if isAuthorised() == false {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    func isAuthorised() -> Bool {
        self.locationManager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse ||
                self.locationManager.authorizationStatus == CLAuthorizationStatus.authorizedAlways
    }

    func getCurrentLocation() -> (lat: Double, long: Double)? {
        if isAuthorised(), let currentLocation = self.locationManager.location {
            return (lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
        }
        return nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.latestCordinates?(location.coordinate.latitude, location.coordinate.longitude)
        }
      }
}
