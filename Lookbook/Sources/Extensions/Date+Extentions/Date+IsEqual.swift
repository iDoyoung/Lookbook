import Foundation

extension Date {
    
    //FIXME: Delete Extention, Readability is not good
    static func isEqual(lhs: Date, rhs: Date) -> Bool {
        let calendar = Calendar.current
        let dateComponents1 = calendar.dateComponents([.year, .month, .day], from: lhs)
        let dateComponents2 = calendar.dateComponents([.year, .month, .day], from: rhs)
        
        guard let dateOnly1 = calendar.date(from: dateComponents1),
              let dateOnly2 = calendar.date(from: dateComponents2) else {
            fatalError("Failed to construct clean dates.")
        }
        
        return dateOnly1 == dateOnly2
    }
}
