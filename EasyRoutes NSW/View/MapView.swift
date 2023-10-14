//
//  MapView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 6/10/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var mapViewModel:MapViewModel
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottomTrailing){
                Map(coordinateRegion: $mapViewModel.focusedRegion, showsUserLocation: true, annotationItems:mapViewModel.transitAnnotation){ annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        NavigationLink(destination:StopAnnotationDetailView(stopAnnotation: annotation)){
                            ZStack{
                                Circle()
                                    .fill(.background)
                                Circle()
                                    .stroke(.secondary,lineWidth:5)
                                Image(systemName: annotation.vehicleIcon)
                                    .foregroundColor(annotation.transitLineColor)
                                    .imageScale(.large)
                                    .padding(5)
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                VStack{
                    if let departureRegion = mapViewModel.departureRegion {
                        Button(action: {
                            mapViewModel.focusedRegion = departureRegion
                        }) {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.blue)
                                .overlay(
                                    Image(systemName: "figure.walk.departure")
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    if let arrivalRegion = mapViewModel.arrivalRegion {
                        Button(action: {
                            mapViewModel.focusedRegion = arrivalRegion
                        }) {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.blue)
                                .overlay(
                                    Image(systemName: "figure.walk.arrival")
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    Button(action: {
                        mapViewModel.updateRegionForUserLocation()
                    }) {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.blue)
                            .overlay(
                                Image(systemName: "location")
                                    .foregroundColor(.white)
                            )
                    }
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
        let mapViewModel = MapViewModel()
        MapView()
            .environmentObject(mapViewModel)
    }
}
