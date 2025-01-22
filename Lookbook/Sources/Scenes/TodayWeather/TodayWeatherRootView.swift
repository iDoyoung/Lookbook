import SwiftUI

struct TodayWeatherRootView: View {
    
    @State var model: TodayWeatherModel
    @AppStorage("is_fahrenheit") var isFahrenheit: Bool = false
    
    var body: some View {
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
                Text(Image(systemName: model.symbolName ?? "questionmark"))
                Text(model.weatherCondition)
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
            }
            .padding(.top, 2)
            .padding(.horizontal)
            
            //MARK: Temperatures
            Text(model.currentTemperature)
                .font(
                    .system(
                        size: 80,
                        weight: .light))
                .padding(.horizontal)
            
            HStack {
                Text(model.maximumTemperatureText)
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                
                Text(model.minimumTemperatureText)
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                    .padding(.bottom, 1)
            }
            .padding(.horizontal)
            
            
            Text(model.feelTemperature)
                .font(
                    .system(
                        size: 16,
                        weight: .bold,
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
                    ForEach(model.todayForcast ?? [], id: \.date) { weather in
                        VStack {
                            Text(weather.date)
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
            Text(model.date)
                .font(
                    .system(
                        size: 10,
                        weight: .light,
                        design: .monospaced))
                .padding()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                locationWarningLabel
                photosWarningLabel
            }
            
            Spacer()
        }
        .padding([.vertical, .leading])
        .background(.thinMaterial)
        .padding(.bottom)
    }
    
    @ViewBuilder
    var locationLabel: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("내 위치")
                    .font(
                        .system(
                            size: 20,
                            weight: .medium))
                    .padding(.top, 6)
            }
            Text(model.locationName)
                .font(.footnote)
                .fontWeight(.semibold)
        }
    }
    
    @ViewBuilder
    var locationWarningLabel: some View {
        if model.locationAuthorizationStatus == .denied {
            Text("⚠️ 위치 접근 권한에 대해 거절 상태입니다. 현재 위치에 날씨 정보를 얻기 위해서 권한을 설정해주세요.")
                .foregroundStyle(.white)
                .font(
                    .system(
                        size: 12,
                        weight: .light))
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(6)
                .background(.black)
                .border(.yellow, width: 2)
                .padding(.horizontal, 6)
                .onTapGesture {
                    openSetting()
                }
        }
    }
   
    @ViewBuilder
    var photosWarningLabel: some View {
        if model.photosAuthorizationStatus == .limited {
            
            // You've given Lookbook access to a select number of photos.
            Text("제한된 사진 접근상태입니다. 더 많은 사진을 가져오기 위해 사진에 접근을 설정해 주세요.")
                .font(
                    .system(
                        size: 12,
                        weight: .light))
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .foregroundStyle(.black)
                .padding(.horizontal, 6)
                .onTapGesture {
                    openSetting()
                }
        } else if model.photosAuthorizationStatus == .restricted || model.photosAuthorizationStatus == .denied {
            
            // Please allow access to your photos
            Text("⚠️ 사진에 접근을 허가해 주세요. 사진을 통해 작년 이맘때 복장을 확인할 수 있어요.")
                .foregroundStyle(.white)
                .font(
                    .system(
                        size: 12,
                        weight: .light))
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .frame(maxWidth: .infinity)
                .padding(6)
                .background(.black)
                .border(.yellow, width: 2)
                .padding(.horizontal, 6)
                .onTapGesture {
                    openSetting()
                }
        }
    }
    
    private func openSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
