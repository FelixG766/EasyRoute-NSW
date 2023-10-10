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

class MapViewModel:ObservableObject{
    
    @Published var focusedRegion: MKCoordinateRegion = MKCoordinateRegion(center: .init(latitude: -33.8837, longitude: 151.2006), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @Published var selectedPlace:CLPlacemark?
    @Published var annotationForSelectedPlace:MKPointAnnotation?
    
    
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
    
}
