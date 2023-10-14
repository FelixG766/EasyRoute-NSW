//
//  StopAnnotationDetailView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 11/10/2023.
//

import SwiftUI
import CoreLocation

struct StopAnnotationDetailView: View {
    
    @State var stopAnnotation:StopAnnotation
    @State private var currentTime = Date()
    private let viewModel = StopAnnotationDetailViewModel()
    //MARK: - Computed property for calculating remining time
    private var remainingTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Australia/Sydney")
        guard let arrivalTime = formatter.date(from: stopAnnotation.sydneyTime) else {
            return "N/A"
        }
        
        let timeRemaining = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime, to: arrivalTime)
        var missed = true
        if let second = timeRemaining.second, let minute = timeRemaining.minute, let hour = timeRemaining.hour {
            missed = (hour + minute + second) < 0
        }
        
        return !missed ? String(format: "%02d:%02d:%02d", timeRemaining.hour ?? 0, timeRemaining.minute ?? 0, timeRemaining.second ?? 0): String("Arrived")
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(stopAnnotation.transitLineColor)
                    .frame(width: 120, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(stopAnnotation.transitLineColor, lineWidth: 2)
                    )
                
                Image(systemName: stopAnnotation.vehicleIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
            }
            .padding(.top, 10)
            
            Text(stopAnnotation.transitLine)
                .font(.largeTitle)
                .foregroundColor(stopAnnotation.transitLineColor)
                .bold()
                .padding(.top, 10)

            Text(stopAnnotation.stop.name)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            
            //MARK: - Display different content for departure and arrival stops
            if stopAnnotation.stopType == "Arrival" {
                Text("Expected Arrival Time:")
                    .font(.title)
                
                Text(stopAnnotation.sydneyTime)
                    .font(.title)
            } else {
                VStack(spacing: 10) {
                    Text("Next Departure in:")
                        .font(.title)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                currentTime = Date()
                            }
                        }
                    Text(remainingTime)
                        .font(.title)
                }
                
                VStack(spacing: 10) {
                    Text("Time Needed for Walking:")
                        .font(.title)
                    Text(viewModel.calculateWalkingDistance(to: CLLocationCoordinate2D(latitude: stopAnnotation.stop.location.latLng.latitude, longitude: stopAnnotation.stop.location.latLng.longitude)))
                        .font(.title)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(20)
        .padding()
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }


}

struct StopAnnotationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let stop = Stop(location: Location(latLng: LatLng(latitude: 37.7749, longitude: -122.4194)), name: "Stop Name")
        let annotation = StopAnnotation(stopType: "Departure", stop: stop, time: "2023-10-12 15:32:00", transitLine: "T4", transitLineColor: Color(hex:"#005aa3"), vehicleIcon: "bus")
        StopAnnotationDetailView(stopAnnotation: annotation)
    }
}
