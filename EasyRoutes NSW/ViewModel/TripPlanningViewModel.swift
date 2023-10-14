//
//  TripPlanningViewModel.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 7/10/2023.
//

import Foundation
import CoreLocation
import SwiftUI
import Contacts
import MapKit
import CoreData

class TripPlanningViewModel:NSObject, ObservableObject{
    
    @Published var startLocationString:String = ""
    @Published var destinationString:String = ""
    @Published var startLocation:CLPlacemark?
    @Published var destination:CLPlacemark?
    @Published var searchResults:[CLPlacemark]?
    @Published var routeSteps: [MKRoute.Step] = []
    @Published var transitStops: [MKMapItem] = []
    @Published var intermediateStops: [String] = []
    @Published var transitLines: [String] = []
    @Published var availableRoutes:[RouteRecord] = []
    @State var currentLocation: CLLocationCoordinate2D? = nil
    @State var locationManager = CLLocationManager()
    private let googleMapServiceManager = GoogleMapServiceManager()
    private let persistenceController = PersistenceController.shared
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    //MARK: - Retrieve user current location
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //MARK: - Switch departure and arrival location
    func switchLocation(){
        //switch location string
        let tempLocationString = startLocationString
        startLocationString = destinationString
        destinationString = tempLocationString
        //switch location placemark
        let tempPlaceMark = startLocation
        startLocation = destination
        destination = tempPlaceMark
        calculateRoute()
    }
    
    //MARK: - Suggest location based on user input
    func suggestLocations(using queryVal:String){
        if(queryVal != ""){
            Task{
                do{
                    let request = MKLocalSearch.Request()
                    
                    request.naturalLanguageQuery = queryVal.lowercased()
                    
                    let response = try await MKLocalSearch(request: request).start()
                    
                    await MainActor.run(body: {
                        self.searchResults = response.mapItems.compactMap({ result -> CLPlacemark in
                            return result.placemark
                        })
                    })
                }
                catch{
                    print(error)
                }
            }
        }
    }
    
    //MARK: - calculate route from departure to destination
    func calculateRoute(){
        if let startLocation = startLocation, let destination = destination {
            self.availableRoutes = []
            googleMapServiceManager.calculateRoute(startPlace: startLocation, destination: destination) { (routesResponse, error) in
                if let error = error {
                    // Handle the error here
                    print("Error calculating route: \(error)")
                }
                else if let routesResponse = routesResponse {
                    // Handle the routes here
                    for route in routesResponse.routes {
                        if let route = route{
                            var newRecord = RouteRecord()
                            for leg in route.legs{
                                if let leg = leg{
                                    for step in leg.steps{
                                        if let transitionDetail = step?.transitDetails{
                                            newRecord.allTransitions.append(TransitDetailsRecord(transitDetails:transitionDetail))
                                        }
                                    }
                                }
                            }
                            self.availableRoutes.append(newRecord)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Save route record
    func trackRoute(routeRecord:RouteRecord,context:NSManagedObjectContext){
        persistenceController.addItem(routeRecord: routeRecord,context: context)
    }
}

//MARK: - Get user current location through GPS function
extension TripPlanningViewModel:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            // Reverse geocode to get the address
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    let formatter = CNPostalAddressFormatter()
                    if let address = placemark.postalAddress {
                        self.startLocationString = formatter.string(from: address)
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }
}
