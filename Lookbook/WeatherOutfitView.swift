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
        ZStack {
            if let data = imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .onDisappear {
                        imageData = nil
                    }
            } else {
                ProgressView()
                    .task {
                        self.imageData = await photoAsset.data()
                    }
            }
            VStack {
                HStack {
                    Text(highTemperature)
                        .foregroundStyle(.white)
                        .font(
                            .system(
                                size: 20,
                                weight: .black,
                                design: .monospaced))
                    
                    Text(lowTemperature)
                        .foregroundStyle(.white)
                        .font(
                            .system(
                                size: 20,
                                weight: .regular,
                                design: .monospaced))
                }
                
                Text(date ?? "")
                    .foregroundStyle(.white)
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
            }
            .padding(6)
            .background(.black.opacity(0.4))
        }
        .aspectRatio(contentMode: .fill)
        .containerRelativeFrame(.vertical)
    }
}
