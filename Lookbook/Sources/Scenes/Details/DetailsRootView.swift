import SwiftUI

struct DetailsRootView: View {
    var model: DetailsModel
    
    @State private var imageScale = 1.0
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
                
                VStack(alignment: .leading) {
                    // 위치
                    HStack {
                        Text(model.location ?? "위치 없음")
                    }
                    // 날씨
                    Text("\(Date().longStyleWithTime)")
                        .dateFont()
                        .padding(.bottom)
                    
                    // 최고 최저 기온
                    HStack {
                        Text("12°")
                            .temperatureFont(weight: .bold)
                        Text("")
                        Text("2°")
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
            .ignoresSafeArea()
        }
    }
    
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, transaction in
                gestureState = value.magnification
            }
            .onEnded { value in
                imageScale *= value.magnification
                if imageScale < 1 {
                    //FIXME: - 빠르게 할 경우 애니메이션 꼬임, 깜빡임
                    withAnimation(.spring) {
                        imageScale = 1
                    }
                }
            }
    }
}

#Preview {
    DetailsRootView(model: .init())
}
