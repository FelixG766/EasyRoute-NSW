//
//  HistoryRoutesView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 6/10/2023.
//

import SwiftUI
import Combine

struct HistoryRoutesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var historyRouteViewModel = HistoryRouteViewModel()
    @EnvironmentObject var mapViewModel:MapViewModel
    @Binding var selectedTab:Int
    
    var body: some View {
        NavigationView{
            List(historyRouteViewModel.savedRoutes) { routeRecord in
                Section(header:
                            HStack{
                    Text("Route Details")
                    Spacer()
                    Button {
                        PersistenceController.shared.deleteRouteHistoryRecord(routeRecord:routeRecord,context: viewContext)
                        historyRouteViewModel.updateHistoryRecords(context: viewContext)
                    } label: {
                        Image(systemName: "delete.left")
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
            .onAppear{
                historyRouteViewModel.updateHistoryRecords(context: viewContext)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Route History", displayMode: .inline)
        }
    }
}

struct HistoryRoutesView_Previews: PreviewProvider {
    static var previews: some View {
        let bindingTab = Binding<Int>(
            get: { 2 }, // Initial value
            set: { _ in }
        )
        let mapViewModel = MapViewModel()
        let persistenceController = PersistenceController.shared
        HistoryRoutesView(selectedTab: bindingTab)
            .environmentObject(mapViewModel)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
