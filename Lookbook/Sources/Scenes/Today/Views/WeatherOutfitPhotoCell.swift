import SwiftUI
import Photos

struct WeatherOutfitPhotoCell: View {
    
    @State var item: TodayModel.WeatherOutfitPhoto
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .aspectRatio(3/4, contentMode: .fit)
                .background(
                    DataImageView(
                        photoAsset: item.asset
                    )
                )
                .clipped()
            
            if let weather = item.weather {
                VStack {
                    Text(weather.date.longStyle)
                        .dateFont(size: 10)
                        .fontWeight(.light)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(3)
                        .background(.ultraThinMaterial)
                        .cornerRadius(4)
                        .padding()
                    
                    Spacer()
                    
                    if let highTemperature = weather.dayTimeMaximumTemperature,
                       let lowTemperature = weather.dayTimeMinimumTemperature {
                        HStack {
                            Text(highTemperature.rounded)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            Text(lowTemperature.rounded)
                                .fontWeight(.thin)
                                .foregroundStyle(.white)
                        }
                        .background(.ultraThinMaterial)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
