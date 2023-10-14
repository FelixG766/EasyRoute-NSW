//
//  TransitionDetailView.swift
//  EasyRoutes NSW
//
//  Created by Yangru Guo on 10/10/2023.
//

import SwiftUI

struct TransitionDetailView: View {
    
    @State var transitDetails: TransitDetails
    let viewModel = TransitDetailViewModel()
    
    var body: some View {
        HStack{
            
            VStack (spacing:15){
                Image(systemName: viewModel.getSignString(transitDetails: transitDetails))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:40,height: 40)
                    .foregroundColor(Color(hex: transitDetails.transitLine.color))
                Text(viewModel.getTransportName(transitDetails:transitDetails))
                    .multilineTextAlignment(.center)
                    .font(viewModel.getTransportNameFont(transitDetails: transitDetails))
                    .fontWeight(viewModel.getTransportNameWeight(transitDetails:transitDetails))
                    .frame(width:80)
            }
            .padding(.trailing,5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(transitDetails.headsign)
                    .padding(.bottom,3)
                    .bold()
                    .font(.system(size:17))
                Text("From \(transitDetails.stopDetails.departureStop.name) To \(transitDetails.stopDetails.arrivalStop.name)")
                    .padding(.bottom,3)
                    .font(.system(size:15))
                HStack {
                    Text("Departure")
                        .font(.system(size:15))
                    Spacer()
                    Text(transitDetails.localizedValues.departureTime.time.text)
                        .font(.system(size:15))
                }
                
                HStack {
                    Text("Arrival")
                        .font(.system(size:15))
                    Spacer()
                    Text(transitDetails.localizedValues.arrivalTime.time.text)
                        .font(.system(size:15))
                }
            }
            .padding(.trailing,12)
        }
        .padding(.top,8)
    }
}

struct TransitionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionDetailView(transitDetails: TransitDetails(
            headsign: "Sample Headsign",
            localizedValues: LocalizedValues(
                arrivalTime: TimeObject(time: TimeString(text: "1:19 AM"), timeZone: "Australia/Sydney"),
                departureTime: TimeObject(time: TimeString(text: "1:13 AM"), timeZone: "Australia/Sydney")
            ),
            stopCount: 4,
            stopDetails: StopDetails(
                arrivalStop: Stop(location: Location(latLng: LatLng(latitude: -33.881428, longitude: 151.205368)), name: "Haymarket"),
                arrivalTime: "2023-10-09T14:19:00Z",
                departureStop: Stop(location: Location(latLng: LatLng(latitude: -33.871582, longitude: 151.207001)), name: "QVB"),
                departureTime: "2023-10-09T14:13:10Z"
            ),
            transitLine: TransitLine(
                agencies: [Agency(name: "Sydney Light Rail", uri: "http://transportnsw.info/")],
                color: "#be1622",
                name: "Randwick Line",
                nameShort: "L2",
                textColor: "#ffffff",
                vehicle: Vehicle(
                    iconUri: "//maps.gstatic.com/mapfiles/transit/iw2/6/tram2.png",
                    localIconUri: "//maps.gstatic.com/mapfiles/transit/iw2/6/au-sydney-tram.png",
                    name: NameString(text: "Light rail"),
                    type: "TRAM"
                )
            )
        ))
    }
}

//MARK: - extend color struct to conver hex string
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

