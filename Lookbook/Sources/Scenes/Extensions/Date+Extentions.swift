import Foundation

extension Date {
    
    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ha"  // "a" -> AM/PM을 나타내는 포맷
        return dateFormatter.string(from: self)
    }
    
    var longStyle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
    
    static func isEqual(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let dateComponents1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let dateComponents2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        guard let dateOnly1 = calendar.date(from: dateComponents1),
              let dateOnly2 = calendar.date(from: dateComponents2) else {
            fatalError("Failed to construct clean dates.")
        }
        
        return dateOnly1 == dateOnly2
    }
}
