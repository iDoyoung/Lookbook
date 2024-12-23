import Foundation

extension Date {
    
    // 1년 5일 전 날짜
    var oneYearAndFiveDaysAgo: Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -1
        dateComponents.day = -5
        
        return calendar.date(byAdding: dateComponents, to: self) ?? self
    }
    
    // 특정 날짜로부터 10일 후
    func tenDaysAfter() -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 10
        
        return calendar.date(byAdding: dateComponents, to: self) ?? self
    }
}
