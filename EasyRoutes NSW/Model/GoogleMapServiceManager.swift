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
    
    //MARK: - Send request for all transit details along target route
    func getTransitDirections(startPlacemark: CLPlacemark, destinationPlacemark: CLPlacemark, completionHandler: @escaping (Result<Any, Error>) -> Void) {
        
        //MARK: - Construct http request
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
            "origin": ["location": originLocation],
            "destination": ["location": destinationLocation],
            "travelMode": "TRANSIT",
            "computeAlternativeRoutes": true,
            "transitPreferences": [
                "routingPreference": "LESS_WALKING",
                "allowedTravelModes": ["TRAIN"]
            ] as [String : Any]
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Goog-Api-Key": SensitiveInfo.GoogleMapService.API_KEY,
            "X-Goog-FieldMask": "routes.legs.steps.transitDetails"
        ]
        
        let apiUrl = "https://routes.googleapis.com/directions/v2:computeRoutes"
        
        //MARK: - Send http request using Alamofire
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
                    completionHandler(.failure(error))
                }
            }
    }
    
    //MARK: - Decode route from json file to custom defined struct
    func decodeRoutes(from jsonObject: Any) -> RouteResponse? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            let decoder = JSONDecoder()
            let response = try decoder.decode(RouteResponse.self, from: jsonData)
            return response
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
    
    //MARK: - Get directions from two places as specified by the user
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
