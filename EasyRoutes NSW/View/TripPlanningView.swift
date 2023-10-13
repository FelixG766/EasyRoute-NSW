//
//  ContentView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 6/10/2023.
//

import SwiftUI
import CoreData
import MapKit
import CoreLocation

struct TripPlanningView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var tripViewModel:TripPlanningViewModel
    @EnvironmentObject var mapViewModel:MapViewModel
    @State private var showingLocationPicker = false
    @State private var currentLocation: CLLocationCoordinate2D?
    @Binding var selectedTab:Int
    @State private var isLocationListTapped:Bool = false
    @State var isStartLocation:Bool?
    @State var isCompleted:Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    VStack(spacing: 25) {
                        Image(systemName: "circle.circle")
                            .imageScale(.small)
                            .foregroundColor(.blue)
                            .font(.title)
                        Image(systemName: "pin.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                            .imageScale(.small)
                    }
                    VStack{
                        TextField("From", text: $tripViewModel.startLocationString)
                            .padding(.vertical,12)
                            .padding(.horizontal)
                            .background{
                                RoundedRectangle(cornerRadius: 10,style:.continuous)
                                    .strokeBorder(.gray)
                            }
                            .onChange(of: tripViewModel.startLocationString) { newValue in
                                if !isLocationListTapped{
                                    tripViewModel.availableRoutes = []
                                    isStartLocation = true
                                    tripViewModel.suggestLocations(using:newValue)
                                }else{
                                    tripViewModel.searchResults = []
                                    isLocationListTapped = false
                                }
                            }
                        TextField("To", text: $tripViewModel.destinationString)
                            .padding(.vertical,12)
                            .padding(.horizontal)
                            .background{
                                RoundedRectangle(cornerRadius: 10,style:.continuous)
                                    .strokeBorder(.gray)
                            }
                            .onChange(of: tripViewModel.destinationString) { newValue in
                                if !isLocationListTapped{
                                    tripViewModel.availableRoutes = []
                                    isStartLocation = false
                                    tripViewModel.suggestLocations(using:newValue)
                                }else{
                                    tripViewModel.searchResults = []
                                    isLocationListTapped = false
                                }
                            }
                    }
                    VStack(spacing:25){
                        Button(action: {
                            tripViewModel.requestLocation()
                        }) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                                .font(.title)
                                .imageScale(.small)
                        }
                        Button(action: {
                            tripViewModel.switchLocation()
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(.blue)
                                .font(.title)
                                .imageScale(.small)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                Divider()
                
                if let suggestions = tripViewModel.searchResults, !suggestions.isEmpty{
                    List(suggestions, id: \.self) { suggestion in
                        HStack(spacing:10){
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.large)
                                .padding(.trailing,10)
                            VStack(alignment:.leading,spacing:10){
                                Text(suggestion.name ?? "")
                                    .font(.subheadline.bold())
                                Text(suggestion.locality ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            //                                mapViewModel.addDragablePin(suggestedPlacemark: suggestion)
                            isLocationListTapped = true;
                            tripViewModel.searchResults = []
                            tripViewModel.currentLocation = suggestion.location?.coordinate
                            if isStartLocation! {
                                tripViewModel.startLocationString = suggestion.name ?? ""
                                tripViewModel.startLocation = suggestion
                            } else{
                                tripViewModel.destinationString = suggestion.name ?? ""
                                tripViewModel.destination = suggestion
                            }
                            
                            //clear suggest list after selecting anyone suggestion
                            tripViewModel.availableRoutes = []
                            tripViewModel.calculateRoute()
                            //                                selectedTab = 1
                            
                        }
                    }
                    .listStyle(.plain)
                }
                
                List(tripViewModel.availableRoutes) { routeRecord in
                    Section(header:
                                HStack{
                        Text("Route Details")
                        Spacer()
                        Button {
                            tripViewModel.trackRoute(routeRecord: routeRecord,context:viewContext)
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                        .padding(.trailing,10)
                    ) {
                        ForEach(routeRecord.allTransitions) { transitionRecord in
                            TransitionDetailView(transitDetails: transitionRecord.transitDetails)
                                .onTapGesture {
                                    mapViewModel.viewTransitionDetailsOnMap(transitionDetails:transitionRecord.transitDetails)
                                    selectedTab = 1
                                }
                        }
                    }
                }
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Route Planner", displayMode: .inline)
        }
        .onTapGesture {
            // Resign the first responder status (dismiss keyboard) on tap
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let bindingTab = Binding<Int>(
            get: { 0 }, // Initial value
            set: { _ in }
        )
        let tripViewModel = TripPlanningViewModel()
        let mapViewModel = MapViewModel()
        TripPlanningView(selectedTab: bindingTab)
            .environmentObject(tripViewModel)
            .environmentObject(mapViewModel)
    }
}
