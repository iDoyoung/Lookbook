import SwiftUI

struct LoadingClassifyUI: View {
    
    @State private var isPulsing = false
    
    var body: some View {
        HStack {
            Text("✨")
                .offset(x: -2, y: -4)
            
            Text("사진 고르는 중...")
                .foregroundStyle(.white)
                .scaleEffect(isPulsing ? 1.05 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: isPulsing
                )
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
        }
        .padding()
        .onAppear {
            isPulsing = true
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(Color.gray)
        LoadingClassifyUI()
    }
}
