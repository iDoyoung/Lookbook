import SwiftUI

struct TodayRootView: View {
   
    @State var model: TodayModel
    @State private var imageOpacity: Bool = false
    @State private var isShowWeatherDetails: Bool = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 3)
    
    var body: some View {
        ZStack {
            VStack {
                if isShowWeatherDetails {
                    EmptyView()
                } else {
                    todayWeatherView
                }
                
                ScrollView {
                    LazyVStack {
                        VStack(alignment: .leading) {
                            Text(model.lastYearSimilarWeatherDateStyleText ?? "")
                                .font(.custom("Futura", size: 20))
                                .italic()
                                .debugBorder()
                            
                            HStack {
                                Text(model.maximumTemperatureText)
                                    .font(
                                        .system(
                                            size: 16,
                                            weight: .bold,
                                            design: .monospaced))
                                Text("⎮")
                                Text(model.minimumTemperatureText)
                                    .font(
                                        .system(
                                            size: 16,
                                            weight: .regular,
                                            design: .monospaced))
                            }
                            .debugBorder()
                            
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
                            
                            
                            Divider()
                                .padding(.vertical)
                            
                            GoogleAdBannerView()
                                .frame(
                                    height: 50,
                                    alignment: .bottom)
                                .debugBorder()
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .debugBorder()
                        
                        HStack(alignment: .center) {
                            Text("작년 이맘때의 옷차림")
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .bold,
                                        design: .monospaced))
                            
                            Spacer()
                        }
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
                .onScrollPhaseChange { oldPhase, newPhase in
                    if isShowWeatherDetails {
                        showWeatherDetails()
                    }
                }
                .frame(maxWidth: .infinity)
                .background()
                .debugBorder()
            }
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
            
            if isShowWeatherDetails {
                    TodayWeatherView(model: model)
                        .onTapGesture {
                            showWeatherDetails()
                        }
            } else {
                EmptyView()
            }
        }
    }
    
    var todayWeatherView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(Image(systemName: model.symbolName ?? "questionmark"))
                Text(model.weatherCondition)
                    .font(
                        .system(
                            size: 16,
                            weight: .light,
                            design: .monospaced))
                Spacer()
            }
            .padding(.bottom, 4)
            
            HStack {
                Text(model.currentTemperature)
                    .font(
                        .system(
                            size: 16,
                            weight: .bold,
                            design: .monospaced))
                Spacer()
                Text(model.lastYearSimilarWeatherDateText ?? "")
                    .font(
                        .system(
                            size: 14,
                            weight: .light,
                            design: .monospaced))
            }
        }
        .padding(.horizontal)
        .onTapGesture {
            showWeatherDetails()
        }
        .debugBorder()

    }
    
    private func showWeatherDetails() {
        withAnimation(.spring()) {
            isShowWeatherDetails.toggle()
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
