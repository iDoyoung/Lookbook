import Foundation

extension Measurement<UnitTemperature> {
    
    var rounded: String {
        "\(self.value.formatted(.number.precision(.fractionLength(0))))" + "º"
    }
}
