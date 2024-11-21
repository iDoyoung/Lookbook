import SwiftUI
import Photos

struct DataImageView: View {
    var photoAsset: PHAsset
    @State private var imageData: Data? = nil
    
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
                .onDisappear {
                    imageData = nil
                }
        } else {
            Rectangle()
                .foregroundStyle(Color(uiColor: .lightGray))
                .scaledToFill()
                .task {
                    self.imageData = await photoAsset.data()
                }
        }
    }
}
