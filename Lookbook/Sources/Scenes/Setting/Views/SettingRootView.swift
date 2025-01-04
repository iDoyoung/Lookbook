import SwiftUI

struct SettingRootView: View {
    
    @AppStorage("is_fahrenheit") var isFahrenheit: Bool = false
    @State private var tempUnitScale: CGFloat = 0.0
    /// Gesture 가 없는 뷰의 Scale 값
    @State private var othersScale: CGFloat = 0.0

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                VStack {
                    Text(isFahrenheit ? UnitTemperature.fahrenheit.symbol: UnitTemperature.celsius.symbol)
                        .font(
                            .system(
                                size: 30,
                                weight: .black))
                        .padding()
                    
                    Text("온도 단위")
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                .frame(width: 70)
                .foregroundColor(Color(uiColor: .label))
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .scaleEffect(tempUnitScale)
                .onLongPressGesture(minimumDuration: 1) {
                    isFahrenheit.toggle()
                } onPressingChanged: { isProgress in
                    withAnimation(.spring) {
                        if isProgress {
                            tempUnitScale -= 0.1
                        } else {
                            tempUnitScale = 1
                        }
                    }
                }
                .simultaneousGesture(
                    TapGesture()
                        .onEnded({ _ in
                            isFahrenheit.toggle()
                        })
                )
                .sensoryFeedback(.selection, trigger: isFahrenheit)
                
                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(
                                .system(
                                    size: 30))
                        Text("Weather")
                            .font(
                                .system(
                                    size: 40,
                                    weight: .medium))
                    }
                    .padding()
                    
                    Text("Other Apple Weather data Sources")
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            if let url = URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/") {
                                UIApplication.shared.open(url)
                            }
                        }
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                .scaleEffect(othersScale)
            }
        }
        .padding()
        .onAppear {
            withAnimation(.spring) {
                tempUnitScale = 1
                othersScale = 1
            }
        }
        .safeAreaPadding(.bottom)
    }
}

#Preview {
    SettingRootView()
}
