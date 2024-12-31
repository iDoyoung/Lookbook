import Foundation

extension Measurement<UnitTemperature> {
    
    var rounded: String {
        let formattedValue = self.value.formatted(.number.precision(.fractionLength(0)))
        let displayValue = formattedValue == "-0" ? "0" : formattedValue
        return displayValue + "º"
    }
}
