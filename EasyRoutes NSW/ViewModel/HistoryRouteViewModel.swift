//
//  HistoryRouteViewModel.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 13/10/2023.
//

import Foundation
import CoreData

class HistoryRouteViewModel:ObservableObject{
    
    @Published var savedRoutes:[RouteRecord] = []
    
    private let persistenceController = PersistenceController.shared
    
    func updateHistoryRecords(context:NSManagedObjectContext){
        savedRoutes = []
        for routeRecordItem in persistenceController.fetchAllRouteRecords(context: context){
            var routeRecord = RouteRecord()
            routeRecord.coreDataID = routeRecordItem.objectID
            var transitDetailsRecords:[TransitDetailsRecord] = []
            if let transitionRecordSet = routeRecordItem.transitionsDetails as? Set<TransitionRecordItem>{
                for transitionRecordItem in  transitionRecordSet {
                    var agencies:[Agency] = []
                    if let agenciesRecord = transitionRecordItem.transitLine?.agencies as? Set<AgencyItem>{
                        for agencyRecordItem in agenciesRecord {
                            agencies.append(
                                Agency(
                                    name: (agencyRecordItem.name)!,
                                    uri: (agencyRecordItem.uri)!
                                )
                            )
                        }
                    }
                    let transitDetails = TransitDetails(
                        headsign: transitionRecordItem.headSign!,
                        localizedValues: LocalizedValues(
                            arrivalTime: TimeObject(
                                time: TimeString(text: (transitionRecordItem.localizedValues?.arrivalTime?.time?.text)!),
                                timeZone: (transitionRecordItem.localizedValues?.arrivalTime?.timeZone)!
                            ),
                            departureTime: TimeObject(
                                time: TimeString(text: (transitionRecordItem.localizedValues?.departureTime?.time?.text)!),
                                timeZone: (transitionRecordItem.localizedValues?.departureTime?.timeZone)!
                            )
                        ),
                        stopCount: Int(transitionRecordItem.stopCount),
                        stopDetails: StopDetails(
                            arrivalStop: Stop(
                                location: Location(
                                    latLng: LatLng(
                                        latitude: (transitionRecordItem.stopDetails?.arrivalStop?.location?.latLng?.latitude)!,
                                        longitude: (transitionRecordItem.stopDetails?.arrivalStop?.location?.latLng?.longitude)!
                                    )
                                ),
                                name:(transitionRecordItem.stopDetails?.arrivalStop?.name)!
                            ),
                            arrivalTime: (transitionRecordItem.stopDetails?.arrivalTime)!,
                            departureStop: Stop(
                                location: Location(
                                    latLng: LatLng(
                                        latitude: (transitionRecordItem.stopDetails?.departureStop?.location?.latLng?.latitude)!,
                                        longitude: (transitionRecordItem.stopDetails?.departureStop?.location?.latLng?.longitude)!
                                    )
                                ),
                                name: (transitionRecordItem.stopDetails?.departureStop?.name)!
                            ),
                            departureTime: (transitionRecordItem.stopDetails?.departureTime)!
                        ),
                        transitLine: TransitLine(
                            agencies: agencies,
                            color: (transitionRecordItem.transitLine?.color)!,
                            name: (transitionRecordItem.transitLine?.name)!,
                            nameShort: transitionRecordItem.transitLine?.nameShort,
                            textColor: (transitionRecordItem.transitLine?.textColor)!,
                            vehicle: Vehicle(
                                iconUri: (transitionRecordItem.transitLine?.vehicle?.iconUri)!,
                                localIconUri: transitionRecordItem.transitLine?.vehicle?.localIconUri,
                                name: NameString(text: (transitionRecordItem.transitLine?.vehicle?.name?.text)!),
                                type: (transitionRecordItem.transitLine?.vehicle?.type)!)
                        )
                    )
                    
                    var transitiDetailsRecord = TransitDetailsRecord(coreDataID:transitionRecordItem.objectID,transitDetails: transitDetails)
                    transitDetailsRecords.append(transitiDetailsRecord)
                }
            }
            routeRecord.allTransitions = transitDetailsRecords
            savedRoutes.append(routeRecord)
        }
    }
}
