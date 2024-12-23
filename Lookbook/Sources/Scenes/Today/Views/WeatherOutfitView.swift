import SwiftUI
import Photos
import CoreLocation

struct WeatherOutfitView: View {
    var photoAsset: PHAsset
    
    @State var location: (current: CLLocation?, photo: CLLocation?)
    @State var date: String?
    @State var locationName: String? = nil
    @State var currentLocation: String?
    @State var lowTemperature: String
    @State var highTemperature: String
    @State private var imageData: Data? = nil
    
    var body: some View {
        ZStack {
            locationView
                .padding(8)
                .background(.ultraThinMaterial)
                .padding()
            
            VStack(alignment: .leading) {
                Spacer()
                VStack {
                    
                    HStack {
                        Text(date ?? "")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .light,
                                    design: .monospaced))
                        
                        Spacer()
                        
                        Text(highTemperature)
                            .font(
                                .system(
                                    size: 20,
                                    weight: .black,
                                    design: .monospaced)
                            )
                        
                        Text(lowTemperature)
                            .font(
                                .system(
                                    size: 20,
                                    weight: .regular,
                                    design: .monospaced)
                            )
                    }
                    .padding(30)
                    .background(
                        Color(UIColor.systemBackground)
                    )
                }
            }
        }
        .task {
            locationName = await location.photo?.name
            currentLocation = await location.current?.name
        }
        .background(
            DataImageView(
                photoAsset: photoAsset
            )
        )
    }
    
    @ViewBuilder
    var locationView: some View {
        if let locationName,
           let currentLocation,
           locationName != currentLocation {
            Text("‼ 아래 날씨는 '\(currentLocation)'에 대한 정보입니다. 사진의 위치인 '\(locationName)'과는 날씨의 차이가 있을 수 있습니다.")
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}
