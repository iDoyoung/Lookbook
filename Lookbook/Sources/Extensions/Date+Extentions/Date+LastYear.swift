import Foundation

extension Date {
    
    ///
    ///
    // 1년 5일 전 날짜
    var oneYearAndFiveDaysAgo: Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -1
        dateComponents.day = -10
        
        return calendar.date(byAdding: dateComponents, to: self) ?? self
    }
    
    // 특정 날짜로부터 10일 후
    func tenDaysAfter() -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 10
        
        return calendar.date(byAdding: dateComponents, to: self) ?? self
    }
    
    /// 작년 같은 달 1일
    var startOfLastYearMonth: Date {
        let calendar = Calendar.current
        
        var dateComponents = calendar.dateComponents([.year, .month], from: self)
        dateComponents.year = dateComponents.year! - 1
        
        return calendar.date(from: dateComponents)!
    }
    
    /// 작년 같은 달 마지막일
    var endOfMonth: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: self)
        components.year! -= 1
        components.month! += 1
        components.day = 1
        let nextMonth = calendar.date(from: components)!
        return calendar.date(byAdding: .day, value: -1, to: nextMonth)!
    }
}
