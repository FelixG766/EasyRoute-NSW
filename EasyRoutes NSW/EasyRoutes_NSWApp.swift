//
//  EasyRoutes_NSWApp.swift
//  EasyRoutes NSW
//
//  Created by Yan Hua on 6/10/2023.
//

import SwiftUI

@main
struct EasyRoutes_NSWApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
