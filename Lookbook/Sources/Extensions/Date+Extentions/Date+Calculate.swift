import Foundation

extension Date {
    
    func calculate(year: Int = 0, month: Int = 0, day: Int = 0) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        return calendar.date(byAdding: dateComponents, to: self)!.dateOnly
    }
}
