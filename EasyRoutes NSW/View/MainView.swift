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
                TripPlanningView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "character.book.closed.fill")
                        Text("Trip Planer")
                    }
                    .environmentObject(tripViewModel)
                    .environmentObject(mapViewModel)
                    .tag(0)
                
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map View")
                    }
                    .environmentObject(mapViewModel)
                    .tag(1)
                HistoryRoutesView(selectedTab: $selectedTab)
                    .tabItem{
                        Image(systemName: "clock")
                        Text("Saved Routes")
                    }
                    .environmentObject(mapViewModel)
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
