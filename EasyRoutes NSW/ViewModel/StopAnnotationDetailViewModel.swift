//
//  StopAnnotationDetailViewModel.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 12/10/2023.
//

import Foundation
import MapKit
import CoreLocation

class StopAnnotationDetailViewModel: NSObject{
    
    private var currentLocation:CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()
    private var formattedTime:String = "Estimating..."
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Estimate time walking from current location to departure stop
    func calculateWalkingDistance(to targetLocation:CLLocationCoordinate2D) -> String{
        if let currentLocation = currentLocation {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: targetLocation))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)

            
            directions.calculate { (response, error) in
                if let route = response?.routes.first {
                    let estimatedTime = route.expectedTravelTime
                    self.formattedTime = self.formatTime(estimatedTime)
                }
            }
        }
        return formattedTime
    }
    
    //MARK: - Convert time for calculation purposes
    func formatTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: time) ?? ""
    }
    
}

extension StopAnnotationDetailViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first?.coordinate {
            currentLocation = userLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)")
    }
}
