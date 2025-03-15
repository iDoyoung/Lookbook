import SwiftUI

struct IslandToastUI<Label: View>: View {
    
    @Binding var isVisible: Bool
    @State private var opacity: Double = 0
    
    private var label: () -> Label
    private var showDuration: Double = 2.0
    
    init(isVisible: Binding<Bool> , label: @escaping () -> Label) {
        self._isVisible = isVisible
        self.label = label
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.black)
                label()
                    .foregroundStyle(.white)
            }
            .frame(height: 100)
            .cornerRadius(50)
            .scaleEffect(isVisible ? 1.0 : 0.1, anchor: .top)
            .opacity(opacity)
            .padding(11)
            .ignoresSafeArea()
            .animation(
                .spring(
                    response: 0.7,
                    dampingFraction: 0.68,
                    blendDuration: 0),
                value: isVisible
            )
            .onChange(of: isVisible) { oldValue, newValue in
                if newValue {
                    opacity = 1
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        opacity = 0
                    }
                }
            }
            Spacer()
        }
    }
}
