//
//  RouteRecord.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 10/10/2023.
//

import Foundation

struct RouteRecord:Identifiable{
    var id = UUID()
    var availableRoute:Route
    var allTransitions:[TransitDetailsRecord] = []
}

struct TransitDetailsRecord:Identifiable{
    var id = UUID()
    var transitDetailRecord:TransitDetails
}
