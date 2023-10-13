//
//  Persistence.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 6/10/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "EasyRoutes_NSW")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func addItem(routeRecord:RouteRecord,context: NSManagedObjectContext) {
        
        let newItem = RouteRecordItem(context: context)
        
        for transitDeatilsRecord in routeRecord.allTransitions {
            
            let newTransitionDetailItem = TransitionRecordItem(context: context)
            
            newTransitionDetailItem.headSign = transitDeatilsRecord.transitDetails.headsign
            
            let newLocalizedValuesItem = LocalizedValuesItem(context: context)
            let arrivalTimeItem = TimeObjectItem(context: context)
            let arrivalTimeStringItem = TimeStringItem(context: context)
            arrivalTimeStringItem.text = transitDeatilsRecord.transitDetails.localizedValues.arrivalTime.time.text
            arrivalTimeItem.time = arrivalTimeStringItem
            arrivalTimeItem.timeZone = transitDeatilsRecord.transitDetails.localizedValues.arrivalTime.timeZone
            newLocalizedValuesItem.arrivalTime = arrivalTimeItem
            let departureTimeItem = TimeObjectItem(context: context)
            let departureTimeStringItem = TimeStringItem(context: context)
            departureTimeStringItem.text = transitDeatilsRecord.transitDetails.localizedValues.departureTime.time.text
            departureTimeItem.time = departureTimeStringItem
            departureTimeItem.timeZone = transitDeatilsRecord.transitDetails.localizedValues.departureTime.timeZone
            newLocalizedValuesItem.departureTime = departureTimeItem
            newTransitionDetailItem.localizedValues = newLocalizedValuesItem
            
            newTransitionDetailItem.stopCount = (Int16)(transitDeatilsRecord.transitDetails.stopCount)
            
            let newStopDetailsItem = StopDetailsItem(context: context)
            let newArrivalStopItem = StopItem(context: context)
            let newArrivalLocationItem = LocationItem(context: context)
            let newArrivalLatLngItem = LatLngItem(context: context)
            newArrivalLatLngItem.latitude = transitDeatilsRecord.transitDetails.stopDetails.arrivalStop.location.latLng.latitude
            newArrivalLatLngItem.longitude = transitDeatilsRecord.transitDetails.stopDetails.arrivalStop.location.latLng.longitude
            newArrivalLocationItem.latLng = newArrivalLatLngItem
            newArrivalStopItem.location = newArrivalLocationItem
            newArrivalStopItem.name = transitDeatilsRecord.transitDetails.stopDetails.arrivalStop.name
            newStopDetailsItem.arrivalStop = newArrivalStopItem
            newStopDetailsItem.arrivalTime = transitDeatilsRecord.transitDetails.stopDetails.arrivalTime
            let newDepartureStopItem = StopItem(context: context)
            let newDepartureLocationItem = LocationItem(context: context)
            let newDepartureLatLngItem = LatLngItem(context: context)
            newDepartureLatLngItem.latitude = transitDeatilsRecord.transitDetails.stopDetails.departureStop.location.latLng.latitude
            newDepartureLatLngItem.longitude = transitDeatilsRecord.transitDetails.stopDetails.departureStop.location.latLng.longitude
            newDepartureLocationItem.latLng = newDepartureLatLngItem
            newDepartureStopItem.location = newDepartureLocationItem
            newDepartureStopItem.name = transitDeatilsRecord.transitDetails.stopDetails.departureStop.name
            newStopDetailsItem.departureStop = newDepartureStopItem
            newStopDetailsItem.departureTime = transitDeatilsRecord.transitDetails.stopDetails.departureTime
            newTransitionDetailItem.stopDetails = newStopDetailsItem
            
            let newTransitLineItem = TransitLineItem(context: context)
            for agency in transitDeatilsRecord.transitDetails.transitLine.agencies{
                let newAgencyItem = AgencyItem(context: context)
                newAgencyItem.name = agency.name
                newAgencyItem.uri = agency.uri
                newAgencyItem.addToParentTransitLine(newTransitLineItem)
            }
            newTransitLineItem.color = transitDeatilsRecord.transitDetails.transitLine.color
            newTransitLineItem.name = transitDeatilsRecord.transitDetails.transitLine.name
            newTransitLineItem.textColor = transitDeatilsRecord.transitDetails.transitLine.textColor
            newTransitLineItem.nameShort = transitDeatilsRecord.transitDetails.transitLine.nameShort
            let newVehicleItem = VehicleItem(context: context)
            newVehicleItem.iconUri = transitDeatilsRecord.transitDetails.transitLine.vehicle.iconUri
            newVehicleItem.localIconUri = transitDeatilsRecord.transitDetails.transitLine.vehicle.localIconUri
            newVehicleItem.type = transitDeatilsRecord.transitDetails.transitLine.vehicle.type
            let newNameString = NameStringItem(context: context)
            newNameString.text = transitDeatilsRecord.transitDetails.transitLine.vehicle.name.text
            newVehicleItem.name = newNameString
            newTransitLineItem.vehicle = newVehicleItem
            newTransitionDetailItem.transitLine = newTransitLineItem
            newItem.addToTransitionsDetails(newTransitionDetailItem)
        }
    
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func fetchAllRouteRecords(context:NSManagedObjectContext) -> [RouteRecordItem]{
        
        let fetchRequest:NSFetchRequest<RouteRecordItem> = RouteRecordItem.fetchRequest()
        
        do{
            let routeRecordItems = try context.fetch(fetchRequest)
            return routeRecordItems
        }catch{
            print(error)
        }
        return []
    }
    
    func deleteRouteHistoryRecord(routeRecord:RouteRecord,context:NSManagedObjectContext) {
        do {
            let routeRecord = try context.existingObject(with:routeRecord.coreDataID!)
            context.delete(routeRecord)
            try context.save()
        } catch {
            print("Error deleting route record: \(error)")
        }
        
    }
}
