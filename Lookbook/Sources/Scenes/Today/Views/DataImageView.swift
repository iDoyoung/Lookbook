import SwiftUI
import Photos

struct DataImageView: View {
    
    @State private var imageData: Data? = nil
    @State var photoAsset: PHAsset?
    
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
        } else {
            Rectangle()
                .foregroundStyle(Color.clear)
                .scaledToFill()
                .task {
                    if let photoAsset {
                        self.imageData = await photoAsset.data()
                    }
                }
        }
    }
}
