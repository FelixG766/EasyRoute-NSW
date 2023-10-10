//
//  MapView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 6/10/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject var mapViewModel:MapViewModel
    @ObservedObject var tripViewModel:TripPlanningViewModel
    @Binding var selectedTab:Int
    
    var body: some View {
        Map(coordinateRegion: $mapViewModel.focusedRegion, showsUserLocation: true)
            .navigationBarTitle("Map View")
            .ignoresSafeArea()
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude && lhs.center.longitude == rhs.center.longitude
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let bindingTab = Binding<Int>(
            get: { 1 }, // Initial value
            set: { _ in }
        )
        let tripViewModel = TripPlanningViewModel()
        let mapViewModel = MapViewModel()
        MapView(mapViewModel:mapViewModel,tripViewModel:tripViewModel,selectedTab: bindingTab)
    }
}
