//
//  GoogleMapServiceManager.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 9/10/2023.
//

import Foundation
import Alamofire
import MapKit

struct GoogleMapServiceManager{
    
    func getTransitDirections(startPlacemark: CLPlacemark, destinationPlacemark: CLPlacemark, completionHandler: @escaping (Result<Any, Error>) -> Void) {
        // Define your request parameters as a dictionary
        let originLocation: [String: Any] = [
            "latLng": [
                "latitude": startPlacemark.location?.coordinate.latitude ?? 0.0,
                "longitude": startPlacemark.location?.coordinate.longitude ?? 0.0
            ]
        ]
        
        let destinationLocation: [String: Any] = [
            "latLng": [
                "latitude": destinationPlacemark.location?.coordinate.latitude ?? 0.0,
                "longitude": destinationPlacemark.location?.coordinate.longitude ?? 0.0
            ]
        ]
        
        let parameters: [String: Any] = [
            "origin": ["location": originLocation], // Use placemark location as origin
            "destination": ["location": destinationLocation], // Use placemark location as destination
            "travelMode": "TRANSIT",
            "computeAlternativeRoutes": true,
            "transitPreferences": [
                "routingPreference": "LESS_WALKING",
                "allowedTravelModes": ["TRAIN"]
            ]
        ]
        
        // Define your headers
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Goog-Api-Key": SensitiveInfo.GoogleMapService.API_KEY,
            "X-Goog-FieldMask": "routes.legs.steps.transitDetails"
        ]
        
        // Define the API URL
        let apiUrl = "https://routes.googleapis.com/directions/v2:computeRoutes"
        
        // Make the HTTP POST request
        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success(let value):
                    if let value = value {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: value, options: .allowFragments)
                            completionHandler(.success(jsonObject))
                        } catch {
                            completionHandler(.failure(error))
                        }
                    }

                case .failure(let error):
                    // Handle the error here
                    completionHandler(.failure(error))
                }
            }
    }
    
    func decodeRoutes(from jsonObject: Any) -> RouteResponse? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            let decoder = JSONDecoder()
            let response = try decoder.decode(RouteResponse.self, from: jsonData)
            // Handle and use the 'routes' array as needed
            return response
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
    
    func calculateRoute(startPlace: CLPlacemark, destination: CLPlacemark, completion: @escaping (RouteResponse?, Error?) -> Void) {
        getTransitDirections(startPlacemark: startPlace, destinationPlacemark: destination) { response in
            switch response {
            case .success(let jsonObject):
                if let response = decodeRoutes(from: jsonObject) {
                    completion(response, nil)
                } else {
                    completion(nil, NSError(domain: "DecodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error decoding routes"]))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
