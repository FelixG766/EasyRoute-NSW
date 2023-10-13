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
    @Published var selectedPlace:CLPlacemark?
    @Published var annotationForSelectedPlace:MKPointAnnotation?
    @Published var transitAnnotation:[StopAnnotation] = []
    private let transitDetailViewModel = TransitDetailViewModel()
    
    func addDragablePin(suggestedPlacemark:CLPlacemark){
        selectedPlace = suggestedPlacemark
        if let coordinate = suggestedPlacemark.location?.coordinate{
            
            focusedRegion = MKCoordinateRegion(center:coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Selected Location"
            self.annotationForSelectedPlace = annotation
            
        }
    }
    
    func updateRegionForUserLocation(_ showUserLocation: Bool) {
        if showUserLocation {
            // Enable user location tracking
            focusedRegion.center = UserLocationManager.shared.userLocation.coordinate
            focusedRegion.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        }
    }
    
    func viewTransitionDetailsOnMap(transitionDetails:TransitDetails){
        //Update StopAnnotation
        transitAnnotation = []
        transitAnnotation.append(StopAnnotation(stopType: "Arrival", stop: transitionDetails.stopDetails.arrivalStop, time: transitionDetails.stopDetails.arrivalTime, transitLine: transitDetailViewModel.getTransportName(transitDetails: transitionDetails), transitLineColor: Color(hex:transitionDetails.transitLine.color), vehicleIcon: transitDetailViewModel.getSignString(transitDetails: transitionDetails)))
        transitAnnotation.append(StopAnnotation(stopType: "Departure", stop: transitionDetails.stopDetails.departureStop, time: transitionDetails.stopDetails.departureTime, transitLine: transitDetailViewModel.getTransportName(transitDetails: transitionDetails), transitLineColor: Color(hex:transitionDetails.transitLine.color), vehicleIcon: transitDetailViewModel.getSignString(transitDetails: transitionDetails)))
        
        //Change focused Region
        focusedRegion.center.latitude = transitionDetails.stopDetails.departureStop.location.latLng.latitude
        focusedRegion.center.longitude = transitionDetails.stopDetails.departureStop.location.latLng.longitude
        focusedRegion.span.longitudeDelta = 0.02
        focusedRegion.span.latitudeDelta = 0.02
    }
    
}
