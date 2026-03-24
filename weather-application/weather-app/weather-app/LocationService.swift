//
//  LocationService.swift
//  weather-app
//
//  Created by Tsotne Shilakadze on 05.02.26.
//

import UIKit
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private var completion: ((Double, Double) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getUserLocation(completion: @escaping (Double, Double) -> Void) {
        self.completion = completion
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            completion(0, 0)
        @unknown default:
            completion(0, 0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            completion?(0, 0)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            completion?(location.coordinate.latitude, location.coordinate.longitude)
            completion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error)
        completion?(0, 0)
    }
}
