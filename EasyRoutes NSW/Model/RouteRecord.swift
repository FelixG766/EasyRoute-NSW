//
//  RouteRecord.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 10/10/2023.
//

import Foundation
import CoreData

//MARK: - Identifiable route record item to be used for initialise list view
struct RouteRecord:Identifiable{
    var id = UUID()
    var coreDataID:NSManagedObjectID?
    var allTransitions:[TransitDetailsRecord] = []
}

struct TransitDetailsRecord:Identifiable{
    var id = UUID()
    var coreDataID:NSManagedObjectID?
    var transitDetails:TransitDetails
}
