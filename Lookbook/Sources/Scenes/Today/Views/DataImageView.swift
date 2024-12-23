import SwiftUI
import Photos

struct DataImageView: View {
    @State private var imageData: Data? = nil
    
    @State var isRotated: Bool = false
    var photoAsset: PHAsset
    @State var animationDelay: Double = 0
    
    var body: some View {
        imageView
    }
    
    @ViewBuilder
    var imageView: some View {
        if let data = imageData,
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .opacity(isRotated ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isRotated ? 30 : 0),
                    axis: (0, 1, 0),
                    anchor: .center
                )
                .onAppear {
                    if isRotated {
                        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay * 0.1) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isRotated.toggle()
                            }
                        }
                    }
                }
                .onDisappear {
                    imageData = nil
                }
        } else {
            Rectangle()
                .foregroundStyle(Color.clear)
                .scaledToFill()
                .task {
                    self.imageData = await photoAsset.data()
                }
        }
    }
}
