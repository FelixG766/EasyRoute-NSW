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
    @State private var isShowingUserLocation = false
    @Binding var selectedTab:Int
    @State private var selectedAnnotation: StopAnnotation?
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottomTrailing) {
                Map(coordinateRegion: $mapViewModel.focusedRegion, showsUserLocation: isShowingUserLocation, annotationItems:mapViewModel.transitAnnotation){ annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        NavigationLink(destination:StopAnnotationDetailView(stopAnnotation: annotation)){
                            VStack{
                                Image(systemName: annotation.vehicleIcon)
                                    .foregroundColor(.blue)
                                    .imageScale(.large)
                            }
                        }
                    }
                    
                }
                .onAppear {
                    mapViewModel.updateRegionForUserLocation(isShowingUserLocation)
                }
                .onDisappear {
                    isShowingUserLocation = false
                    mapViewModel.updateRegionForUserLocation(false)
                }
                .navigationBarTitle("Map View")
                .ignoresSafeArea()
                
                Button(action: {
                    isShowingUserLocation.toggle()
                    mapViewModel.updateRegionForUserLocation(isShowingUserLocation)
                }) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.blue)
                        .overlay(
                            Image(systemName: "location")
                                .foregroundColor(.white)
                        )
                }
                .padding()
            }
        }
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
