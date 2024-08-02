import Foundation

final class UserSetting {
    @UserDefault(key: "is_fahrenheit", defaultValue: false)
    static var isFahrenheit: Bool
}
