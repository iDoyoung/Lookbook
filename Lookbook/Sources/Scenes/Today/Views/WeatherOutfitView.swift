import SwiftUI
import Photos
import CoreLocation

struct WeatherOutfitView: View {
    var photoAsset: PHAsset
    var location: CLLocation?
    
    @State var date: String?
    @State var locationName: String? = nil
    @State var lowTemperature: String
    @State var highTemperature: String
    @State private var imageData: Data? = nil
    
    var body: some View {
        VStack {
            Spacer()
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
                            design: .monospaced))
                
                Text(lowTemperature)
                    .font(
                        .system(
                            size: 20,
                            weight: .regular,
                            design: .monospaced))
            }
            .padding(30)
            .background(
                Color(UIColor.systemBackground)
            )
        }
        .background(
                DataImageView(photoAsset: photoAsset)
        )
    }
}
