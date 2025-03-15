import Foundation
import Photos
import UIKit
import CoreLocation
import os

@Observable
final class TodayModel {
    
    struct WeatherOutfitPhoto {
        var id: String { asset.localIdentifier }
        let asset: PHAsset
        let weather: DailyWeather?
    }
    
    enum Destination {
        case setting
        case details(model: DetailsModel)
        case todayWeather
    }
    
    // States
    var destination: Destination? = nil
    var isLoading: Bool = false
    var locationState: LocationServiceState {
        didSet {
            Task { @MainActor in
                locationName = await locationState.location?.name ?? "알 수 없음"
            }
        }
    }
    
    var photosState: PhotosState
    
    var locationName: String? = nil
    var presentSetting: Bool = false
    var unitTemperature: UnitTemperature = .celsius
    
    var dateRange: (start: Date, end: Date) {
        let now = Date()
        
        let startDate = now.calculate(year: -1, month: -1)
        let endDate = startDate.calculate(month: 3, day: -1)
        
        return (startDate, endDate)
    }
   
    // MARK: - Weather 모델 리펙토링하기
    var weather: CurrentlyWeather? = nil
    
    /// 작년 이맘때 3개월의 날씨
    var lastYearWeathers: [DailyWeather]? = nil
    var sortedAveragedWeathers: [DailyWeather] {
        lastYearWeathers?.sorted { first, second in
            // 현재 날씨의 평균 기온이 nil인 경우 처리
            guard let currentTemp = weather?.averageTemperature else {
                return false
            }
            
            // 각 날씨와 현재 기온과의 차이 계산 (절대값)
            let firstDiff = abs(first.averageTemperature.value - currentTemp.value)
            let secondDiff = abs(second.averageTemperature.value - currentTemp.value)
            
            return firstDiff < secondDiff
        } ?? []
    }
    
    //TODO: Refactor - 날씨관련 프로퍼티 수정필요
    
    /// 오늘과 가장 비슷한 옷 스타일 추천
    var recommendedPHAsset: PHAsset? {
        photosState.assets?.filter({ asset in
            return asset.creationDate?.dateOnly == lastYearSimilarWeather?.date.dateOnly
        }).first
    }
    
    /// 작년 사진과 날씨를 비교해 비슷한 날짜 구하기
    var lastYearSimilarWeather: DailyWeather? {
        if sortedAveragedWeathers.isEmpty == false {
            guard let photosCreateDates = photosState.assets?.compactMap({ $0.creationDate?.dateOnly }) else {
                return sortedAveragedWeathers.first ?? nil
            }
            
            return sortedAveragedWeathers
                .first { weather in
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
    
    var currentTemperature: String {
        weather?.current?.temperature.converted(to: unitTemperature).rounded ?? "--"
    }
    
    var todayHighTemperatureText: String {
        weather?.maximumTemperature?.converted(to: unitTemperature).rounded ?? ""
    }
    
    var todayLowTemperatureText: String {
        weather?.minimumTemperature?.converted(to: unitTemperature).rounded ?? ""
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
   
    var weatherOutfitPhotoItems: [WeatherOutfitPhoto] {
        return sortedAveragedWeathers.flatMap { weather in
            let matchingAssets = photosState.assets?.filter { asset in
                guard let assetCreateDate = asset.creationDate else { return false }
                return weather.date.dateOnly == assetCreateDate.dateOnly
            } ?? []
            
            return matchingAssets.map { asset in
                WeatherOutfitPhoto(
                    asset: asset,
                    weather: weather
                )
            }
        }
    }
    
    /// 금일 시간별 날씨 정보
    var todayForcast: [TodayForecast]? {
        return weather?.hourlyForecast?.compactMap({ weather in
            TodayForecast(hourlyWeather: weather, unit: unitTemperature)
        })
    }
    
    init(
        locationState: LocationServiceState,
        photosState: PhotosState = .init()
    ) {
        self.locationState = locationState
        self.photosState = photosState
        Task { @MainActor in
            self.locationName = await locationState.location?.name
        }
    }
}
