import SwiftUI

extension View {
    func debugBorder(_ color: Color = .blue, width: CGFloat = 1) -> some View {
        #if DEBUG
        return border(color, width: width)
        #else
        return self
        #endif
    }
}
