//
//  SettingView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 6/10/2023.
//

import SwiftUI

struct SettingView: View {
    
    @AppStorage("darkModeEnabled") var darkModeEnabled = false
    @State private var pushNotificationsEnabled = false
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("General")) {
                    HStack{
                        Image(systemName: "moon")
                            .padding(.trailing)
                            .foregroundColor(.blue)
                        Toggle("Dark Mode", isOn: $darkModeEnabled)
                            .onChange(of: darkModeEnabled){newVal in
                                AppSettings.toggleDarkMode(newVal: newVal)
                            }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
