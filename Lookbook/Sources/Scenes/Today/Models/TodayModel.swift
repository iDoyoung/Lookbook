import Foundation
import Photos
import UIKit
import CoreLocation
import os

@Observable
final class TodayModel {
    
    private let logger: Logger = Logger(subsystem: "io.doyoung.Lookbook.TodayModel", category: "Observable Model")
    enum Destination { case setting, details(asset: PHAsset) }
    
    // States
    var destination: Destination? = nil
   
    var locationState: LocationServiceState
    var photosState: PhotosState
    
    var locationName: String? = nil
    var presentSetting: Bool = false
    var unitTemperature: UnitTemperature = .celsius
    
    var dateRange: (start: Date, end: Date) {
        let now = Date()
        let startDate = now.oneYearAndFiveDaysAgo
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 20
        
        let endDate = calendar.date(byAdding: .day, value: 20, to: startDate) ?? startDate
        
        return (now.oneYearAndFiveDaysAgo, endDate)
    }
   
    // MARK: - Weather 모델 리펙토링하기
    var weather: CurrentlyWeather? = nil
    
    /// 작년 이맘때, 20일 간 날씨
    var lastYearWeathers: [DailyWeather]? = nil
    
    //TODO: Refactor - 날씨관련 프로퍼티 수정필요
    
    /// 오늘과 가장 비슷한 옷 스타일 추천
    var recommendedPHAsset: PHAsset? {
        photosState.assets?.filter({ asset in
            return  asset.creationDate?.dateOnly == lastYearSimilarWeather?.date.dateOnly
        }).first
    }
    
    /// 작년 사진과 날씨를 비교해 비슷한 날짜 구하기
    private var lastYearSimilarWeather: DailyWeather? {
        if let lastYearWeathers,
            !lastYearWeathers.isEmpty {
            guard let photosCreateDates = photosState.assets?.compactMap({ $0.creationDate?.dateOnly }) else {
                  return lastYearWeathers.first ?? nil
              }

              return lastYearWeathers.first { weather in
                  let date = weather.date
                  return photosCreateDates.contains(date)
              }
          } else {
              return nil
          }
    }
    
    var lastYearSimilarWeatherDateText: String? {
        if let date = lastYearSimilarWeather?.date {
            return "작년 \(date.styleMMddKOR)과 비슷한 기온이에요"
        } else if let lastYearFirst = lastYearWeathers?.first?.date {
            return "작년 \(lastYearFirst.longStyle)과 비슷한 기온이에요"
        } else {
            return nil
        }
    }
    
    var lastYearSimilarWeatherDateStyleText: String? {
        if let date = lastYearSimilarWeather?.date {
            return "\(date.longStyle)의 스타일"
        } else {
            return nil
        }
    }
    
    var currentTemperature: String {
        weather?.current?.temperature.converted(to: unitTemperature).rounded ?? "--"
    }
    
    var maximumTemperature: Double? {
        weather?.dailyForecast?[0].maximumTemperature.value
    }
    
    var minimumTemperature: Double? {
        weather?.dailyForecast?[0].minimumTemperature.value
    }
    
    var symbolName: String? {
        weather?.current?.symbolName
    }
    
    var weatherCondition: String {
        weather?.current?.condition ?? ""
    }
    
    var maximumTemperatureText: String {
        "최고:" + (weather?.dailyForecast?[0].maximumTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var minimumTemperatureText: String {
        "최저:" + (weather?.dailyForecast?[0].minimumTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var maximumTemperatureOfLastYearSimilarWeatherText: String {
        "최고:" + (lastYearSimilarWeather?.maximumTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var minimumTemperatureOfLastYearSimilarWeatherText: String {
        "최저:" + (lastYearSimilarWeather?.minimumTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var feelTemperature: String {
        "체감 온도:" + (weather?.current?.feelTemperature.converted(to: unitTemperature).rounded ?? "--")
    }
    
    var todayForcast: [TodayForecast]? {
        return weather?.hourlyForecast?.compactMap({ weather in
            TodayForecast(hourlyWeather: weather, unit: unitTemperature)
        })
    }
    
    var outfitPhotos: [OutfitPhoto] {
        return photosState.assets?.compactMap { asset in
            let filteredWeather = lastYearWeathers?
                .filter { weather in
                    guard let assetCreateDate = asset.creationDate else { return false }
                    return Date.isEqual(lhs: weather.date, rhs: assetCreateDate)
                }
                .first
            
            return OutfitPhoto(
                asset: asset,
                highTemp: filteredWeather?.maximumTemperature.converted(to: unitTemperature).rounded ?? "",
                lowTemp: filteredWeather?.minimumTemperature.converted(to: unitTemperature).rounded ?? ""
            )
        } ?? []
    }
    
    init(
        locationState: LocationServiceState,
        photosState: PhotosState = .init()
    ) {
        self.locationState = locationState
        self.photosState = photosState
    }
}
