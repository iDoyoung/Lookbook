import Foundation

extension Date {
    var dateOnly: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}
