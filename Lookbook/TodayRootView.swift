import SwiftUI

struct TodayRootView: View {
    
    @State var model: TodayModel
    @State var image: UIImage? = nil
    
    var tapLocationWaringLabel: () -> Void
    
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
                       
                ZStack(alignment: .center) {
                    Circle()
                        .foregroundStyle(.black)
                        .frame(
                            width: 15,
                            height: 15,
                            alignment: .center)
                }
                .frame(maxWidth: .infinity)
                
                //MARK: Location Label
                locationLabel
                
                //MARK: Weather Condition
                HStack {
                    Text(Image(systemName: model.weather?.current?.symbolName ?? "questionmark"))
                    Text(model.weather?.current?.condition ?? "")
                        .font(
                            .system(
                                size: 16,
                                weight: .light,
                                design: .monospaced))
                }
                .padding(.top, 2)
         
                //MARK: Temperatures
                Text(model.weather?.current?.temperature ?? "--")
                    .font(
                        .system(
                            size: 80,
                            weight: .light))
                
                HStack {
                    Text("최고:\(model.weather?.dailyForecast?[0].maximumTemperature ?? "--")")
                        .font(
                            .system(
                                size: 16,
                                weight: .light,
                                design: .monospaced))
                    
                    Text("최저:\(model.weather?.dailyForecast?[0].minimumTemperature ?? "--")")
                        .font(
                            .system(
                                size: 16,
                                weight: .light,
                                design: .monospaced))
                        .padding(.bottom, 1)
                }
                
                Text("체감 온도: \(model.weather?.current?.feelTemperature ?? "--")")
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                    .padding(.vertical, 1)
                
                // - MARK:
                Divider()
                    .padding(.top)
                
                // MARK: Houly Forecast
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(model.weather?.hourlyForecast ?? [], id: \.date) { weather in
                            VStack {
                                
                                Text(weather.date.hour)
                                    .font(
                                        .system(
                                            size: 14,
                                            weight: .light,
                                            design: .monospaced))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                
                                Image(systemName: weather.symbolName)
                                    .padding(.vertical, 1)
                                
                                Text(weather.temperature)
                                    .font(
                                        .system(
                                            size: 14,
                                            weight: .light,
                                            design: .monospaced))
                            }
                        }
                    }
                }
                
                Spacer()
                
                //MARK: Today Date
                Text("\(Date())")
                    .font(
                        .system(
                            size: 10,
                            weight: .light,
                            design: .monospaced))
                    .padding(.vertical)
//                photosWarningLabel
//                    .background(.white)
//                
//                locationWarningLabel
//                    .background(.black)
            }
            .frame(
                width: 240,
                alignment: .leading)
            .padding()
            .background(.thinMaterial)
            .padding()
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
    
    @ViewBuilder
    var locationLabel: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Location")
                    .font(
                        .system(
                            size: 20,
                            weight: .medium))
                    .padding(.top, 6)
            }
            
            Text(model.location?.name ?? "알 수 없음")
                .font(.footnote)
                .fontWeight(.semibold)
        }
    }
    
    @ViewBuilder
    var locationWarningLabel: some View {
        if model.locationAuthorizationStatus == .unauthorized {
            Text("⚠️ 위치 접근 권한에 대해 거절 상태입니다. 정확한 현재 위치를 알 수 없어서, 현재 위치에 날씨 정보를 얻기 위해서는 탭해주세요.")
                .foregroundStyle(.white)
                .font(
                    .system(
                        size: 12,
                        weight: .light))
                .padding()
                .onTapGesture {
                    // Show Alert
                    tapLocationWaringLabel()
                }
        }
    }
    
    @ViewBuilder
    var photosWarningLabel: some View {
        if model.photosAuthorizationStatus == .restrictedOrDenied {
            Text("You've given Lookbook access to a select number of photos.")
                .font(
                .system(
                    size: 12,
                    weight: .light))
                .foregroundStyle(.black)
                .padding()
        } else if model.photosAuthorizationStatus == .restrictedOrDenied {
            Text("Please allow access to your photos")
                .font(
                    .system(
                        size: 12,
                        weight: .light))
                .foregroundStyle(.black)
                .padding()
        }
    }
}

#Preview {
    var image = UIImage(named: "sample_image.JPG")
    
    return TodayRootView(
        model: .init(),
        image: image,
        tapLocationWaringLabel: {
            print("Tap")
        }
    )
}
