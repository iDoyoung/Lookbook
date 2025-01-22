import Foundation

extension Date {
    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ha"  // "a" -> AM/PM을 나타내는 포맷
        return dateFormatter.string(from: self)
    }
    
    var styleMMddKOR: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "MM월 dd일"
        return dateFormatter.string(from: self)
    }
    
    var longStyle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
    
    var longStyleWithTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
