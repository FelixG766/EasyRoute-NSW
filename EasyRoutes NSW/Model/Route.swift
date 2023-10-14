//
//  TransitModel.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 9/10/2023.
//

import Foundation

//MARK: - Nested construt to store different level of info regarding transit route
struct RouteResponse:Codable {
    let routes:[Route?]
}

struct Route: Codable,Identifiable{
    let legs: [Leg?]
    var id: UUID {
        return UUID()
    }
}

struct Leg: Codable{
    let steps: [Step?]
}

struct Step: Codable{
    let transitDetails: TransitDetails?
}

struct TransitDetails: Codable {
    let headsign: String
    let localizedValues: LocalizedValues
    let stopCount: Int
    let stopDetails: StopDetails
    let transitLine: TransitLine
}

struct LocalizedValues: Codable {
    let arrivalTime: TimeObject
    let departureTime: TimeObject
}

struct TimeObject: Codable{
    let time:TimeString
    let timeZone:String
}

struct TimeString:Codable{
    let text:String
}

struct StopDetails: Codable {
    let arrivalStop: Stop
    let arrivalTime: String
    let departureStop: Stop
    let departureTime: String
}

struct Stop: Codable {
    let location: Location
    let name: String
}

struct Location: Codable {
    let latLng: LatLng
}

struct LatLng: Codable {
    let latitude: Double
    let longitude: Double
}

struct TransitLine: Codable {
    let agencies: [Agency]
    let color: String
    let name: String
    let nameShort: String?
    let textColor: String
    let vehicle: Vehicle
}

struct Agency: Codable {
    let name: String
    let uri: String
}

struct Vehicle: Codable {
    let iconUri: String
    let localIconUri: String?
    let name: NameString
    let type: String
}

struct NameString: Codable {
    let text: String
}















