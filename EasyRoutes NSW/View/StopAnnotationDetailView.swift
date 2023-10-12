//
//  StopAnnotationDetailView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 11/10/2023.
//

import SwiftUI


struct StopAnnotationDetailView: View {
    
    @State var stopAnnotation:StopAnnotation
    @State private var currentTime = Date()
    private let viewModel = StopAnnotationDetailViewModel()
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
            VStack{
                Image(systemName: stopAnnotation.vehicleIcon)
                    .foregroundColor(stopAnnotation.transitLineColor)
                    .imageScale(.large)
                Text(stopAnnotation.stop.name)
                    .font(.title)
                    .bold()
                    .padding()
            }
            if stopAnnotation.stopType == "Arrival" {
                HStack{
                    Text("This is the arival stop for")
                        .font(.title2)
                    Text(stopAnnotation.transitLine)
                        .font(.title2)
                        .foregroundColor(stopAnnotation.transitLineColor)
                        .bold()
                }
                Text("Will arrival at \(stopAnnotation.sydneyTime)")
            }else{
                HStack{
                    Text("Please catch")
                        .font(.title2)
                    Text(stopAnnotation.transitLine)
                        .font(.title)
                        .foregroundColor(stopAnnotation.transitLineColor)
                        .bold()
                }
                .padding(.bottom)
                VStack(spacing:5){
                    Text("Will departure in")
                        .font(.title)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                currentTime = Date()
                            }
                        }
                    Text(remainingTime)
                        .font(.title)
                }
                .padding()
            }
            Spacer()
        }
        .onAppear{
            print(currentTime,stopAnnotation.sydneyTime)
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct StopAnnotationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let stop = Stop(location: Location(latLng: LatLng(latitude: 37.7749, longitude: -122.4194)), name: "Stop Name")
        let annotation = StopAnnotation(stopType: "Departure", stop: stop, time: "2023-10-12 15:32:00", transitLine: "T4", transitLineColor: Color(hex:"#005aa3"), vehicleIcon: "bus")
        StopAnnotationDetailView(stopAnnotation: annotation)
    }
}
