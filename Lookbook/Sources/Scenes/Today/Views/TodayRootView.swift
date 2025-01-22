import SwiftUI
import Photos

struct TodayRootView: View {
    
    @State var model: TodayModel
    @State private var imageOpacity: Bool = false
    @State private var isShowWeatherDetails: Bool = false
    
    @State private var lastOffset: CGFloat = 0.0
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 3)
    
    var body: some View {
        ZStack {
            VStack {
                todayWeatherView
                ScrollView {
                    LazyVStack {
                        VStack(alignment: .leading) {
                            Text("사진에서 가져온 작년의 옷차림들입니다.\n이렇게 입어보는것은 어떨까요?")
                                .font(.caption2)
                                .padding(.top)
                                .padding(.bottom, 4)
                            
                            Text(model.lastYearSimilarWeatherDateStyleText ?? "")
                                .dateFont()
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 30,
                                    alignment: .leading
                                )
                            
                            if let asset = model.recommendedPHAsset {
                                Rectangle()
                                    .fill(Color.clear)
                                    .aspectRatio(3/4, contentMode: .fit)
                                    .background(
                                        DataImageView(
                                            photoAsset: asset
                                        )
                                    )
                                    .clipped()
                                    .border(Color(uiColor: .label))
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        model.destination = .details(model: DetailsModel(asset: asset))
                                    }
                                
                            } else {
                                // TODO: 사진이 없는 경우 UI 구현
                                Rectangle()
                                    .fill(Color(uiColor: .secondarySystemBackground).opacity(0.4))
                                    .aspectRatio(3/4, contentMode: .fit)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .debugBorder()
                        
                        Divider()
                            .padding()
                        
                        Text("\(model.dateRange.start.longStyle)~\n\(model.dateRange.end.longStyle)")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .medium,
                                    design: .monospaced))
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(.horizontal)
                            .debugBorder()
                        
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(model.weatherOutfutPhotoItems, id: \.id) { photo in
                                Rectangle()
                                    .fill(Color.clear)
                                    .aspectRatio(3/4, contentMode: .fit)
                                    .background(
                                        DataImageView(
                                            photoAsset: photo.asset
                                        )
                                    )
                                    .clipped()
                                    .onTapGesture {
                                        model.destination = .details(
                                            model: DetailsModel(
                                                asset: photo.asset,
                                                weather: photo.weather
                                            )
                                        )
                                    }
                            }
                        }
                        .padding(.bottom)
                       
                        Text("Look Weather 의 날씨 예보는 아래로부터 제공받은 데이터 소스를 기반으로 합니다.")
                            .font(
                                .system(
                                    size: 12,
                                    weight: .light
                                )
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding([.vertical, .leading])
                            .padding(.top, 60)

                        HStack {
                            appleWeatherLabel
                            Spacer()
                        }
                    }
                    .debugBorder()
                }
                .scrollIndicators(.hidden)
                .onScrollPhaseChange { oldPhase, newPhase, context in
                    isShowWeatherDetails = false
                    lastOffset = context.geometry.contentOffset.y
                }
                .frame(maxWidth: .infinity)
                .background()
                .debugBorder()
            }
            .background(Color(uiColor: .label))
            .frame(maxWidth: .infinity)
        }
    }
    
    //MARK: - Today Weather View
    private var todayWeatherView: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(Image(systemName: model.symbolName ?? "questionmark"))
                        .font(
                            .system(
                                size: 20,
                                weight: .bold)
                        )
                        .foregroundStyle(Color(uiColor: .systemBackground))
                    
                    Text(model.weatherCondition)
                        .font(
                            .system(
                                size: 20,
                                weight: .bold,
                                design: .monospaced)
                        )
                        .foregroundStyle(Color(uiColor: .systemBackground))
                    
                    Spacer()
                }
                .padding(.bottom, 4)
                
                HStack(alignment: .bottom) {
                    Text(model.currentTemperature)
                        .temperatureFont(weight: .bold)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .padding(.trailing, 8)
                    
                    Spacer()
                    Text(model.todayHighTemperatureText)
                        .temperatureFont(size: 16, weight: .medium)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                    Text(model.todayLowTemperatureText)
                        .temperatureFont(size: 16, weight: .light)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                    
                }
                .debugBorder()
            }
            
            Image(systemName: "chevron.right")
                .resizable()
                .foregroundStyle(Color(uiColor: .systemBackground).opacity(0.8))
                .fontWeight(.medium)
                .frame(
                    width: 8,
                    height: 40
                )
                .padding(.leading)
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            model.destination = .todayWeather
        }
    }
    
    private var appleWeatherLabel: some View {
        VStack {
            HStack {
                Image(systemName: "apple.logo")
                    .font(
                        .system(
                            size: 24))
                Text("Weather")
                    .font(
                        .system(
                            size: 32))
            }
            .padding(.bottom, 8)
            
            Text("Other Apple Weather data Sources")
                .font(
                    .system(
                        size: 12,
                        weight: .light
                    )
                )
                .foregroundStyle(.blue)
        }
        .padding()
        .onTapGesture {
            if let url = URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/") {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    TodayRootView(
        model: .init(
            locationState: .init(),
            photosState: .init()
        )
    )
}
