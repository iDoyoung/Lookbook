import Foundation
@testable import Lookbook

extension DailyWeather {
    static func stub(
        date: Date = Date(),
        dayTimeMaxTemperature: Double = 25.0,
        dayTimeMinTemperature: Double = 20.0,
        condition: String = "맑음",
        symbolName: String = "sun.max.fill",
        maxTemperature: Double = 27.0,
        minTemperature: Double = 18.0,
        precipitationChance: Int = 0
    ) -> DailyWeather {
        return DailyWeather(
            date: date,
            dayTimeMaximumTemperature: Measurement(value: dayTimeMaxTemperature, unit: .celsius),
            dayTimeMinimumTemperature: Measurement(value: dayTimeMinTemperature, unit: .celsius),
            condition: condition,
            symbolName: symbolName,
            maximumTemperature: Measurement(value: maxTemperature, unit: .celsius),
            minimumTemperature: Measurement(value: minTemperature, unit: .celsius),
            precipitationChance: precipitationChance
        )
    }
    
    // 여러 일자의 날씨 데이터가 필요한 경우를 위한 헬퍼 메서드
    static func stubs(
        count: Int = 7,
        startingFrom date: Date = Date(),
        baseMaxTemperature: Double = 25.0,
        baseMinTemperature: Double = 18.0
    ) -> [DailyWeather] {
        return (0..<count).map { day in
            let dayDate = Calendar.current.date(byAdding: .day, value: day, to: date)!
            
            // 날짜별로 약간의 온도 변화를 주어 현실적인 테스트 데이터 생성
            let maxVariation = Double(day % 3) - 1 // -1~1도 변화
            let minVariation = Double(day % 3) - 1 // -1~1도 변화
            
            let maxTemp = baseMaxTemperature + maxVariation
            let minTemp = baseMinTemperature + minVariation
            let dayTimeMaxTemp = maxTemp - 2 // 주간 최고기온은 하루 최고기온보다 약간 낮게
            let dayTimeMinTemp = minTemp + 2 // 주간 최저기온은 하루 최저기온보다 약간 높게
            
            return stub(
                date: dayDate,
                dayTimeMaxTemperature: dayTimeMaxTemp,
                dayTimeMinTemperature: dayTimeMinTemp,
                maxTemperature: maxTemp,
                minTemperature: minTemp,
                precipitationChance: day % 2 == 0 ? 30 : 0 // 격일로 30% 강수확률
            )
        }
    }
}
