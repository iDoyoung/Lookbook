import SwiftUI

struct TodayRootView: View {
    
    @State var temp: String
    @State var maxTemp: String
    @State var minTemp: String
    
    @State var weatherCondition: String
    @State var weatherIcon: String
    
    @State var location: String
    @State var forecast: [String]
    
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
                
                Text(temp)
                    .font(
                        .system(
                            size: 80,
                            weight: .light,
                            design: .monospaced))
                
                Text(maxTemp)
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                
                Text(minTemp)
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                    .padding(.bottom, 1)
                
                HStack {
                    Text(Image(systemName: weatherIcon))
                    Text(weatherCondition)
                        .font(
                            .system(
                                size: 16,
                                weight: .light,
                                design: .monospaced))
                }
                .padding(.vertical, 1)
                
                Text("체감 온도: 22º")
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                    .padding(.vertical, 1)
                
                Spacer()
                
                HStack {
                    Text(Image(systemName: "location.fill"))
                    
                    Text(location)
                        .font(
                            .system(
                                size: 16,
                                weight: .light,
                                design: .monospaced))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(forecast, id: \.self) { text in
                            Text(text)
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
    var temp = "22º"
    var max = "최고:23º"
    var min = "최저:13º"
    var location = "수원"
    var forecast = [
        "4PM-27º",
        "5PM-27º",
        "6PM-27º",
        "7PM-27º"
    ]
    var image = UIImage(named: "sample_image.JPG")
    
    return TodayRootView(
        temp: temp,
        maxTemp: max,
        minTemp: min,
        weatherCondition: "Mostly Clear",
        weatherIcon: "sun.max",
        location: location, 
        forecast: forecast,
        image: image)
}
