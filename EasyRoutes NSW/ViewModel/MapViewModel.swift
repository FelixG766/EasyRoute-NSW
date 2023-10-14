//
//  MapViewModel.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 6/10/2023.
//

import Foundation
import MapKit
import CoreData
import SwiftUI
import Combine
import Alamofire

class MapViewModel:ObservableObject{
    
    @Published var focusedRegion: MKCoordinateRegion = MKCoordinateRegion(center: .init(latitude: -33.8837, longitude: 151.2006), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @Published var transitAnnotation:[StopAnnotation] = []
    @Published var directions:MKRoute?
    @Published var departureRegion:MKCoordinateRegion?
    @Published var arrivalRegion:MKCoordinateRegion?

    
    private let transitDetailViewModel = TransitDetailViewModel()
    
    
    func updateRegionForUserLocation() {
        focusedRegion.center = UserLocationManager.shared.userLocation.coordinate
        focusedRegion.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
    
    //MARK: - Add departure and arrival stop to the map
    func viewTransitionDetailsOnMap(transitionDetails:TransitDetails){
        //Update StopAnnotation
        transitAnnotation = []
        transitAnnotation.append(StopAnnotation(stopType: "Arrival", stop: transitionDetails.stopDetails.arrivalStop, time: transitionDetails.stopDetails.arrivalTime, transitLine: transitDetailViewModel.getTransportName(transitDetails: transitionDetails), transitLineColor: Color(hex:transitionDetails.transitLine.color), vehicleIcon: transitDetailViewModel.getSignString(transitDetails: transitionDetails)))
        transitAnnotation.append(StopAnnotation(stopType: "Departure", stop: transitionDetails.stopDetails.departureStop, time: transitionDetails.stopDetails.departureTime, transitLine: transitDetailViewModel.getTransportName(transitDetails: transitionDetails), transitLineColor: Color(hex:transitionDetails.transitLine.color), vehicleIcon: transitDetailViewModel.getSignString(transitDetails: transitionDetails)))
        
        //Get coordinates for departure and arrival
        let departureCoordinate = CLLocationCoordinate2D(latitude: transitionDetails.stopDetails.departureStop.location.latLng.latitude, longitude: transitionDetails.stopDetails.departureStop.location.latLng.longitude)
        let arrivalCoordinate = CLLocationCoordinate2D(latitude: transitionDetails.stopDetails.arrivalStop.location.latLng.latitude, longitude: transitionDetails.stopDetails.arrivalStop.location.latLng.longitude)
        //Change focused Region
        focusedRegion.center = departureCoordinate
        focusedRegion.span.longitudeDelta = 0.02
        focusedRegion.span.latitudeDelta = 0.02
        departureRegion = MKCoordinateRegion(center: departureCoordinate, span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02))
        arrivalRegion = MKCoordinateRegion(center: arrivalCoordinate, span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02))
        calculateDirectionsBetweenAnnotations(departureStopCoordinates: departureCoordinate, arrivalStopCoordinates: arrivalCoordinate)
    }
    
    //MARK: - Calculate directions between two stop through transit
    func calculateDirectionsBetweenAnnotations(departureStopCoordinates:CLLocationCoordinate2D,arrivalStopCoordinates:CLLocationCoordinate2D){
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: departureStopCoordinates))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: arrivalStopCoordinates))
        request.transportType = .transit

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error calculating directions: \(error.localizedDescription)")
                }
                return
            }

            self.directions = response.routes.first
        }
    }
    
}
