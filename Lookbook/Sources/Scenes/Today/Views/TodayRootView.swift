import SwiftUI

struct TodayRootView: View {
    
    @State var model: TodayModel
    
    var body: some View {
        VStack {
            VStack {
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
                    Text("작년 12월 31일과 비슷한 기온이에요")
                        .font(
                            .system(
                                size: 14,
                                weight: .light,
                                design: .monospaced))
                }
            }
            .padding()
            .debugBorder()
            
            ScrollView {
                LazyVStack {
                    VStack(alignment: .leading) {
                        Text("2023.12.31 STYLE")
                            .font(.custom("Futura", size: 20))
                            .italic()
                            .debugBorder()
                        
                        DataImageView(photoAsset: model.photosState.assets?.first)
                            .border(
                                Color(uiColor: .label),
                                width: 2
                            )
                            .debugBorder()
                        
                        HStack {
                            Text(model.maximumTemperature)
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .bold,
                                        design: .monospaced))
                            Text("⎮")
                            Text(model.minimumTemperature)
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .regular,
                                        design: .monospaced))
                        }
                        .debugBorder()
                        
                        GoogleAdBannerView()
                            .frame(
                                height: 50,
                                alignment: .bottom)
                            .debugBorder()
                        
                        
                        Divider()
                            .padding(.vertical)
                        
                        HStack(alignment: .center) {
                            Text("2023년 12월의 옷차림들")
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .bold,
                                        design: .monospaced))
                            
                            Spacer()
                            Text("기온차")
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .bold,
                                        design: .monospaced))
                                .padding(.vertical, 6)
                                .padding(.horizontal)
                                .background(.mint)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.top, 6)
                        .debugBorder()
                        
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .debugBorder()
                }
                .debugBorder()
            }
            .frame(maxWidth: .infinity)
            .debugBorder()
        }
        .frame(maxWidth: .infinity)
    }
    
    var currentWeather: some View {
        HStack {
            
        }
        .padding()
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
