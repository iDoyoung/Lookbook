import SwiftUI

struct DetailsRootView: View {
    var model: DetailsModel
    
    var body: some View {
        VStack {
            if let photoData = model.imageData,
               let uiImage = UIImage(data: photoData){
                Rectangle()
                    .fill(.clear)
                    .aspectRatio(3/4, contentMode: .fit)
                    .background(
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    )
                    .clipped()
            } else {
                Rectangle()
            }
            
            VStack(alignment: .leading) {
                // 위치
                HStack {
                    Text("테스트")
                }
                // 날씨
                Text("\(Date().longStyle)")
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
            .debugBorder(Color.red)
        }
    }
}

#Preview {
    DetailsRootView(model: .init())
}
