import SwiftUI
import Photos

struct TodayRootView: View {
    
    @State var model: TodayModel
    @State private var isScrolling = false
    @State private var isHiddenWeatherTag: Bool = false
    
    var tapLocationWaringLabel: () -> Void
    
    var body: some View {
        ZStack {
            // 작년 복장 사진
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(model.outfitPhotos, id: \.id) { photo in
                        WeatherOutfitView(
                            photoAsset: photo.asset,
                            location: photo.location,
                            date: photo.creationDate,
                            lowTemperature: photo.lowTemp,
                            highTemperature: photo.highTemp
                        )
                        .scaledToFill()
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            
            // 오늘 날씨 정보
            VStack(alignment: .leading) {
                
                // 펀치 홀 UI
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
                    .padding([.top, .horizontal])
                
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
                .padding(.horizontal)
                
                //MARK: Temperatures
                Text(model.weather?.current?.temperature ?? "--")
                    .font(
                        .system(
                            size: 80,
                            weight: .light))
                    .padding(.horizontal)
                
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
                .padding(.horizontal)
                
                
                Text("체감 온도: \(model.weather?.current?.feelTemperature ?? "--")")
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                    .padding(.vertical, 1)
                    .padding(.horizontal)
                
                // - MARK:
                Divider()
                    .padding(.vertical, 1)
                    .padding(.horizontal)
                
                
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
                .contentMargins(10)
                
                //MARK: Today Date
                Text("\(Date())")
                    .font(
                        .system(
                            size: 10,
                            weight: .light,
                            design: .monospaced))
                    .padding()
                
                Spacer()
                
                GoogleAdBannerView()
                    .frame(height: 50, alignment: .bottom)
                
                HStack {
                    Image(systemName: "info.circle.fill")
                        .frame(width: 20)
                        .aspectRatio(1, contentMode: .fit)
                }
                .padding()
            }
            .frame(
                width: 240,
                alignment: .leading)
            .padding(.top)
            .background(.background.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        .black.opacity(0.9),
                        lineWidth:1))
            .padding(.vertical, 60)
            .rotation3DEffect(.degrees(isHiddenWeatherTag ? -81 : 0), axis: (1, 0, 0), anchor: .top)
        }
        .ignoresSafeArea()
        .onTapGesture { position in
            withAnimation {
                isHiddenWeatherTag.toggle()
            }
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
