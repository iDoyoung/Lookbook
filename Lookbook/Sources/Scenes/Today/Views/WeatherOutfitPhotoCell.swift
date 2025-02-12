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
                    
                    HStack {
                        Spacer()
                        
                        HStack {
                            Text(weather.maximumTemperature.rounded)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Text(weather.minimumTemperature.rounded)
                                .fontWeight(.thin)
                                .foregroundStyle(.white)
                        }
                        .padding(3)
                        .background(.ultraThinMaterial)
                        .cornerRadius(4)
                        .padding(2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
