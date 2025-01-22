import Foundation
@testable import Lookbook

extension CurrentlyWeather {
    static func stub(
        temperature: Double = 20.0,
        feelTemperature: Double = 22.0,
        condition: String = "맑음",
        symbolName: String = "sun.max.fill",
        date: Date = Date()
    ) -> CurrentlyWeather {
        let current = Current(
            date: date,
            temperature: Measurement(value: temperature, unit: .celsius),
            feelTemperature: Measurement(value: feelTemperature, unit: .celsius),
            condition: condition,
            symbolName: symbolName
        )
        
        return CurrentlyWeather(
            current: current,
            hourlyForecast: [HourlyWeather.stub()],
            dailyForecast: [DailyWeather.stub()]
        )
    }
}
