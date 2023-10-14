//
//  TransitDetailViewModel.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 10/10/2023.
//

import Foundation
import SwiftUI

class TransitDetailViewModel{
    
    //MARK: - Get system name of icon
    func getSignString(transitDetails:TransitDetails) -> String{
        let typeString = transitDetails.transitLine.vehicle.type.lowercased()
        if containsTrainTransportKeywords(typeString){
            return "tram.fill"
        }else{
            return "bus.fill"
        }
    }
    
    //MARK: - Check if transit vehicle is train or bus
    func containsTrainTransportKeywords(_ inputString: String) -> Bool {
        let keywords = ["train", "rail", "subway", "locomotive", "commuter", "railway", "transit", "metro","tram"]
        
        for keyword in keywords {
            if inputString.localizedCaseInsensitiveContains(keyword) {
                return true
            }
        }
        
        return false
    }
    
    //MARK: - Get transport name
    func getTransportName(transitDetails:TransitDetails) -> String {
        if let shortName = transitDetails.transitLine.nameShort {
            return shortName
        }else{
            return transitDetails.headsign
        }
    }
    
    //MARK: - Different weight for different typle of name
    func getTransportNameWeight(transitDetails:TransitDetails) -> Font.Weight{
        if let _ = transitDetails.transitLine.nameShort {
            return .bold
        }else{
            return .regular
        }
    }
    
    //MARK: - Different font size for different type of name
    func getTransportNameFont(transitDetails: TransitDetails) -> Font{
        if let _ = transitDetails.transitLine.nameShort {
            return .title3
        }else{
            return .caption
        }
    }
    
}
