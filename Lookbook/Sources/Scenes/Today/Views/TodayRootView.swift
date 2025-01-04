import SwiftUI

struct TodayRootView: View {
   
    @State var model: TodayModel
    @State private var imageOpacity: Bool = false
    @State private var isShowWeatherDetails: Bool = false
    @State private var hideCurrntWeather: Bool = false
    
    @State private var lastOffset: CGFloat = 0.0
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 3)
    
    var body: some View {
        ZStack {
            VStack {
                if hideCurrntWeather {
                    EmptyView()
                } else {
                    todayWeatherView
                }
                
                ScrollView {
                    LazyVStack {
                        VStack(alignment: .leading) {
                            Text("사진에서 가져온 작년의 옷차림들입니다.\n이렇게 입어보는것은 어떨까요?")
                                .font(.caption2)
                                .padding(.top)
                                .padding(.bottom, 4)
                            
                            Text(model.lastYearSimilarWeatherDateStyleText ?? "")
                                .font(.custom("Futura", size: 20))
                                .italic()
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 30,
                                    alignment: .leading
                                )
                                .debugBorder(.blue)
                           
                            if let photoAsset = model.recommendedPHAsset {
                                
                                Rectangle()
                                    .fill(Color.clear)
                                    .aspectRatio(3/4, contentMode: .fit)
                                    .background(
                                        DataImageView(
                                            photoAsset: photoAsset
                                        )
                                    )
                                    .border(
                                        Color(uiColor: .label),
                                        width: 2
                                    )
                                    .rotation3DEffect(
                                        .degrees(imageOpacity ? 0 : 50),
                                        axis: (0, 1, 0),
                                        anchor: .center
                                    )
                                    .onAppear {
                                        withAnimation(.easeIn(duration: 0.3)) {
                                            imageOpacity = true
                                        }
                                    }
                                    .clipped()
                                    .debugBorder()
                            } else {
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
                            ForEach(model.outfitPhotos, id: \.id) { photo in
                                Rectangle()
                                    .fill(Color.clear)
                                    .aspectRatio(3/4, contentMode: .fit)
                                    .background(
                                        DataImageView(
                                            photoAsset: photo.asset
                                        )
                                    )
                                    .clipped()
                            }
                        }
                        
                        //MARK: - Weather Kit
                        VStack {
                            HStack {
                                Image(systemName: "apple.logo")
                                    .font(
                                        .system(
                                            size: 30))
                                Text("Weather")
                                    .font(
                                        .system(
                                            size: 40,
                                            weight: .medium))
                            }
                            .padding()
                            
                            Text("Other Apple Weather data Sources")
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    if let url = URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        
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
            
            if isShowWeatherDetails {
                TodayWeatherView(model: model)
                    .onTapGesture {
                        isShowWeatherDetails = false
                    }
            } else {
                EmptyView()
            }
        }
    }
    
    //MARK: - Today Weather View
    var todayWeatherView: some View {
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
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .monospaced)
                    )
                    .foregroundStyle(Color(uiColor: .systemBackground))
                
                Spacer()
                
                Text(model.lastYearSimilarWeatherDateText ?? "")
                    .font(
                        .system(
                            size: 16,
                            weight: .regular,
                            design: .monospaced)
                    )
                    .foregroundStyle(Color(uiColor: .systemBackground))
            }
            .debugBorder(.yellow)
        }
        .padding(.horizontal)
        .onTapGesture {
            isShowWeatherDetails = true
        }
        .debugBorder()

    }
    
    private func toggleHideCurrntWeather(_ isHidden: Bool) {
        withAnimation(.spring()) {
            hideCurrntWeather = isHidden
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
