import SwiftUI
import Photos

struct AsyncImage: View {
    
    let asset: PHAsset
    
    @State private var imageData: Data? = nil
    
    var body: some View {
        if let data = imageData,
           let uiImage = UIImage(data: data)  {
            Image(uiImage: uiImage)
                .resizable()
                .onDisappear {
                    imageData = nil
                }
        } else {
            ProgressView()
                .task {
                    imageData = await asset.data()
                }
        }
    }
}
