//
//  AppSettings.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 14/10/2023.
//

import Foundation
import SwiftUI
struct AppSettings{
    
    static func toggleDarkMode(newVal:Bool){
        
        guard let firstUIScen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        guard let firstWindow = firstUIScen.windows.first else {
            return
        }
        
        if newVal {
            // Change to Dark Mode
            firstWindow.overrideUserInterfaceStyle = .dark
        } else {
            // Change to Light Mode
            firstWindow.overrideUserInterfaceStyle = .light
        }
    }
}
