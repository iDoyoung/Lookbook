import Foundation
@testable import Lookbook

extension HourlyWeather {
    static func stub(
           date: Date = Date(),
           temperature: Double = 22.0,
           feelTemperature: Double = 23.0,
           condition: String = "맑음",
           symbolName: String = "sun.max.fill",
           precipitationChance: Int = 0
       ) -> HourlyWeather {
           return HourlyWeather(
               date: date,
               temperature: Measurement(value: temperature, unit: .celsius),
               feelTemperature: Measurement(value: feelTemperature, unit: .celsius),
               condition: condition,
               symbolName: symbolName,
               precipitationChance: precipitationChance
           )
       }
       
       // 여러 시간대의 날씨 데이터가 필요한 경우를 위한 헬퍼 메서드
       static func stubs(
           count: Int = 24,
           startingFrom date: Date = Date(),
           baseTemperature: Double = 22.0
       ) -> [HourlyWeather] {
           return (0..<count).map { hour in
               let hourDate = Calendar.current.date(byAdding: .hour, value: hour, to: date)!
               // 시간대별로 약간의 온도 변화를 주어 현실적인 테스트 데이터 생성
               let temperature = baseTemperature + Double(hour % 5) - 2
               
               return stub(
                   date: hourDate,
                   temperature: temperature,
                   feelTemperature: temperature + 1,
                   precipitationChance: hour % 3 == 0 ? 20 : 0
               )
           }
       }
}
