import Foundation
import os

@propertyWrapper
struct UserDefault<T> {
    private let logger: Logger = Logger(subsystem: "io.doyoung.Lookbook.UserDefault", category: "User Defaults")
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            let value = UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            logger.log("Get \(String(describing: value)) in User Defaults")
            return value
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            logger.log("Set \(String(describing: newValue)) in User Defaults")
        }
    }
}
