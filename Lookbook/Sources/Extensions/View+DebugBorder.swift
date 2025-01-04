import SwiftUI

extension View {
    func debugBorder(_ color: Color = .clear, width: CGFloat = 1) -> some View {
        #if DEBUG
        return border(color, width: width)
        #else
        return self
        #endif
    }
}
