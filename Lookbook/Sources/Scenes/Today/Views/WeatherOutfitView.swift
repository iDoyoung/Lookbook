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
                    .foregroundStyle(.white)
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                
                Spacer()
                
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
            .padding()
        }
        .background(
            imageView
        )
        .containerRelativeFrame(.vertical)
    }
    
    @ViewBuilder
    var imageView: some View {
        if let data = imageData,
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .onDisappear {
                    imageData = nil
                }
        } else {
            Rectangle()
                .foregroundStyle(Color(uiColor: .lightGray))
                .scaledToFill()
                .task {
                    self.imageData = await photoAsset.data()
                }
        }
    }
}

#Preview {
    var preview = WeatherOutfitView(
        photoAsset: PHAsset.init(),
        location: nil,
        date: "qwer qwer",
        locationName: "nil",
        lowTemperature: "qwerty",
        highTemperature: "qwerty"
    )
   
    return preview
}
