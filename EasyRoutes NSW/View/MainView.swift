//
//  SwiftUIView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 6/10/2023.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = 0
    @ObservedObject var tripViewModel:TripPlanningViewModel = TripPlanningViewModel()
    @ObservedObject var mapViewModel:MapViewModel = MapViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group{
                TripPlanningView(tripViewModel: tripViewModel, mapViewModel: mapViewModel, selectedTab: $selectedTab)
//                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                    .tabItem {
                        Image(systemName: "character.book.closed.fill")
                        Text("Trip Planer")
                    }
                    .tag(0)
                
                MapView(mapViewModel:mapViewModel,tripViewModel:tripViewModel,selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map View")
                    }
                    .tag(1)
                HistoryRoutesView()
                    .tabItem{
                        Image(systemName: "clock")
                        Text("Saved Routes")
                    }
                    .tag(2)
                
                SettingView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .toolbarBackground(Color.gray.opacity(0.1), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
