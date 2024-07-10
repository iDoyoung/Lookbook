import SwiftUI
import Photos

struct AsyncImage: View {
    
    let asset: PHAsset
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        Task.detached { @MainActor in
            self.image = await asset.uiImage()
        }
    }
}
