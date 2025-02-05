import SwiftUI
import Photos
import CoreLocation

struct RecommendedOutfitPhotoView: View {
    
    @State var asset: PHAsset
    @State var date: Date?
    @State var highTemperature: String?
    @State var lowTemperature: String?
   
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .fill(Color.clear)
                .aspectRatio(3/4, contentMode: .fit)
                .background(
                    DataImageView(
                        photoAsset: asset
                    )
                )
                .clipped()
            
            VStack(alignment: .leading) {
                Text(date?.longStyle ?? "")
                    .dateFont(size: 12)
                    .fontWeight(.light)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding([.horizontal, .top], 8)
                
                if let highTemperature,
                   let lowTemperature {
                    HStack {
                        Text(highTemperature)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text(lowTemperature)
                            .fontWeight(.thin)
                            .foregroundStyle(.white)
                    }
                    .padding([.horizontal, .bottom], 8)
                }
            }
            .background(.ultraThinMaterial)
            .cornerRadius(4)
            .padding()
        }
    }
}
