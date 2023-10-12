//
//  UserLocationManager.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 10/10/2023.
//

import Foundation
import CoreLocation

class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = UserLocationManager()
    @Published var userLocation: CLLocation = CLLocation()

    private let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
        }
    }
}
