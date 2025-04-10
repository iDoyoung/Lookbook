import SwiftUI
import Photos

struct TodayRootView: View {
    
    @State var model: TodayModel
    @State private var imageOpacity: Bool = false
    @State private var isShowWeatherDetails: Bool = false
    
    @State private var lastOffset: CGFloat = 0.0
    @State private var blurRadius: CGFloat = 30
    @State private var showLoadingToast: Bool = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 1), count: 3)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ScrollView {
                    LazyVStack {
                        //TODO: 가독성 향상
                        VStack(alignment: .leading) {
                            HStack {
                                switch model.photosState.authorizationStatus {
                                case .authorized:
                                    Text("사진에서 가져온 작년의 옷차림들입니다.\n이렇게 입어보는것은 어떨까요?")
                                        .font(.caption2)
                                        .padding(.top)
                                        .padding(.bottom, 4)
                                case .limited:
                                    Text("사진에서 가져온 작년의 옷차림들입니다.\n이렇게 입어보는것은 어떨까요?\n(설정을 업데이트하여 더 많은 사진을 가져와 보세요.)")
                                        .font(.caption2)
                                        .padding(.top)
                                        .padding(.bottom, 4)
                                    
                                case .restricted, .denied:
                                    HStack(alignment: .center) {
                                        Text("⚠️")
                                        Text("사진에 접근할 수 있도록 허가해 주세요. 사진을 통해 작년 이맘때 복장을 확인할 수 있어요.")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                    }
                                    .padding(.top)
                                    .padding(.bottom, 4)
                                default:
                                    EmptyView()
                                }
                                
                                Spacer()
                            }
                            
                            if let asset = model.recommendedPHAsset {
                                RecommendedOutfitPhotoView(
                                    asset: asset,
                                    date: model.lastYearSimilarWeather?.date,
                                    highTemperature: model.lastYearSimilarWeather?.maximumTemperature.rounded,
                                    lowTemperature: model.lastYearSimilarWeather?.minimumTemperature.rounded
                                )
                                .border(Color(uiColor: .label))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    model.destination = .details(model: DetailsModel(asset: asset))
                                }
                                .blur(radius: blurRadius)
                                .onAppear {
                                    withAnimation {
                                        blurRadius = 0
                                    }
                                }
                                
                            } else {
                                // TODO: 사진이 없는 경우 UI 구현
                                ZStack {
                                    Rectangle()
                                        .fill(Color(uiColor: .secondarySystemBackground).opacity(0.4))
                                        .aspectRatio(3/4, contentMode: .fit)
                                    if model.isLoading == false, model.weatherOutfitPhotoItems.isEmpty {
                                        Text("작년 이맘때의 옷차림 사진을 찾을 수 없습니다.\n추천을 받기 위해서는 여러분의 사진에 옷차림 사진이 있어야 해요!")
                                            .font(.footnote)
                                            .foregroundStyle(Color(uiColor: .secondaryLabel))
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .debugBorder()
                        
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                        
                        Text("\(model.dateRange.start.longStyle)~\(model.dateRange.end.longStyle)")
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
                        
                        LazyVGrid(columns: columns, spacing: 1) {
                            ForEach(model.weatherOutfitPhotoItems, id: \.id) { photo in
                                WeatherOutfitPhotoCell(item: photo)
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
                        .padding(.bottom, 200)
                    }
                    .debugBorder()
                }
                .scrollIndicators(.hidden)
                .onScrollPhaseChange { oldPhase, newPhase, context in
                    isShowWeatherDetails = false
                    lastOffset = context.geometry.contentOffset.y
                }
                .frame(maxWidth: .infinity)
                .debugBorder()
                Spacer()
            }
            
            todayWeatherView
                .background(.regularMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal, 12)
            
            IslandToastUI(isVisible: $showLoadingToast) {
                LoadingClassifyUI()
            }
            .onChange(of: model.isLoading) { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        if model.isLoading {
                            showLoadingToast = true
                        }
                    }
                } else {
                    showLoadingToast = false
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
    }
    
    //MARK: - Today Weather View
    private var todayWeatherView: some View {
        VStack(alignment: .leading) {
            //TODO: 가독성 향상
            HStack {
                Text(model.locationName ?? "")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Spacer()
                if model.locationState.authorizationStatus == .denied ||
                    model.locationState.authorizationStatus == .restricted ||
                    model.photosState.authorizationStatus == .denied ||
                    model.photosState.authorizationStatus == .restricted {
                    Text("‼️")
                }
            }
            .padding([.top, .horizontal])
            
            HStack(alignment: .bottom) {
                Text(model.currentTemperature)
                    .temperatureFont(size: 26, weight: .bold)
                
                Text(model.weatherCondition)
                    .temperatureFont(size: 16, weight: .semibold)
                    .opacity(0.6)
                
                Spacer()
                Text(model.todayHighTemperatureText)
                    .temperatureFont(size: 16, weight: .medium)
                Text(model.todayLowTemperatureText)
                    .temperatureFont(size: 16, weight: .light)
            }
            .padding(.horizontal)
            .debugBorder()
            
            Divider()
                .padding(.horizontal)
            
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
        }
        .contentShape(Rectangle())
        .onTapGesture {
            model.destination = .todayWeather
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
