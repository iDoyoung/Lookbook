import SwiftUI
import UIKit

struct DetailsRootView: View {
    var model: DetailsModel
    
    @State private var imageScale = 1.0
    @State private var isShowWeatherData = true
    @GestureState private var magnifyBy = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if let photoData = model.imageData,
                   let uiImage = UIImage(data: photoData){
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(magnifyBy*imageScale)
                        .frame(
                            width: geometry.size.width
                        )
                        .clipped()
                        .gesture(magnification)
                } else {
                    Rectangle()
                }
                
                if isShowWeatherData {
                    VStack(alignment: .leading) {
                        // 위치
                        HStack {
                            Text(model.location ?? "위치 없음")
                        }
                        
                        Text(model.creationDateText)
                            .dateFont()
                            .padding(.bottom)
                        
                        // 최고 최저 기온
                        HStack {
                            Text(model.maximumTemperature)
                                .temperatureFont(weight: .bold)
                            Text(model.minimumTemperature)
                                .temperatureFont()
                        }
                        .padding(.bottom)
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding()
                    .background(.regularMaterial)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, transaction in
                if imageScale * value.magnification > 0.5 {
                    gestureState = value.magnification
                }
                withAnimation(.easeIn) {
                    isShowWeatherData = false
                }
            }
            .onEnded { value in
                imageScale *= value.magnification
                if imageScale < 1 {
                    //FIXME: - 빠르게 할 경우 애니메이션 꼬임, 깜빡임
                    withAnimation(.easeIn) {
                        imageScale = 1
                        isShowWeatherData = true
                    }
                }
            }
    }
}
