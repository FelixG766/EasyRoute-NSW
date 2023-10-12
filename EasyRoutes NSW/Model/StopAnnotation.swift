//
//  TransitAnnotation.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 11/10/2023.
//

import Foundation
import CoreLocation
import SwiftUI

struct StopAnnotation:Identifiable{
    var id = UUID()
    var stopType: String
    var stop: Stop
    var time:String
    var sydneyTime:String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let utcDate = dateFormatter.date(from: time) {
            dateFormatter.timeZone = TimeZone(abbreviation: "Australia/Sydney")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: utcDate)
        }
        
        return time
    }
    var transitLine:String
    var transitLineColor: Color
    var vehicleIcon:String
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: stop.location.latLng.latitude, longitude: stop.location.latLng.longitude)
    }
}
