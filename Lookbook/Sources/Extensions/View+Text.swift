import SwiftUI

extension Text {
    
    func dateFont(
        size: CGFloat = 20
    ) -> some View {
        return self
            .font(.custom("Futura", size: size))
            .italic()
    }
    
    func temperatureFont(
        size: CGFloat = 20,
        weight: Font.Weight = .regular) -> some View {
            return self
                .font(
                    .system(
                        size: size,
                        weight: weight,
                        design: .monospaced)
                )
            
        }
}
