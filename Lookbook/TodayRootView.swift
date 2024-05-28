import SwiftUI

struct TodayRootView: View {
    
    @State var weather = TheDayWeather()
    @State var image: UIImage? = nil
    
    var body: some View {
        ZStack(alignment: .leading) {
        
            // 작년 복장 사진
            Rectangle()
                .overlay {
                    outfitImage
                        .scaledToFill()
                }
                .ignoresSafeArea()
            
            // 오늘 날씨 정보
            VStack(alignment: .leading) {
                
                Text("Today")
                    .padding(.bottom, 6)
                
                Text("\(Date())")
                    .font(
                        .system(
                            size: 10,
                            weight: .light,
                            design: .monospaced))
                
                Text(weather.temp ?? "--")
                    .font(
                        .system(
                            size: 80,
                            weight: .light,
                            design: .monospaced))
                
                Text(weather.maxTemp ?? "--")
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                
                Text(weather.minTemp ?? "--")
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                    .padding(.bottom, 1)
                
                HStack {
                    Text(Image(systemName: weather.iconName ?? "questionmark"))
                    Text(weather.condition ?? "")
                        .font(
                            .system(
                                size: 16,
                                weight: .light,
                                design: .monospaced))
                }
                .padding(.vertical, 1)
                
                Text("체감 온도: \(weather.feelTemp ?? "--")")
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                    .padding(.vertical, 1)
                
                Spacer()
                
                HStack {
                    Text(Image(systemName: "location.fill"))
                    
                    Text("현재 위치")
                        .font(
                            .system(
                                size: 16,
                                weight: .light,
                                design: .monospaced))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(weather.forecast, id: \.date) { weather in
                            Text(weather.temp ?? "--")
                                .font(
                                    .system(
                                        size: 12,
                                        weight: .light,
                                        design: .monospaced))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .frame(
                width: 240,
                alignment: .leading)
            .padding()
            .background(.thinMaterial)
        }
    }
    
    @ViewBuilder
    var outfitImage: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
        } else {
            Text("Hello, world!")
        }
    }
}

#Preview {
    var location = "수원"
    
    var image = UIImage(named: "sample_image.JPG")
    
    return TodayRootView(
        image: image
    )
}
