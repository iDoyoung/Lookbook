//
//  SettingRootView.swift
//  Lookbook
//
//  Created by Doyoung on 7/31/24.
//

import SwiftUI

struct SettingRootView: View {
    
    @State var temperatureUnit: UnitTemperature

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                
                // 앱 정보
                HStack {
                    // app icon image
                    
                    // 앱이름
                    
                }
                
                VStack {
                    Text(temperatureUnit.symbol)
                        .font(
                            .system(
                                size: 30,
                                weight: .black))
                        .padding()
                    
                    Text("온도 단위")
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                .frame(width: 70)
                .foregroundColor(Color(uiColor: .label))
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                .onTapGesture {
                    // TODO: Save in User Default
                    if temperatureUnit == UnitTemperature.celsius {
                        temperatureUnit = UnitTemperature.fahrenheit
                    } else if temperatureUnit == UnitTemperature.fahrenheit {
                        temperatureUnit = UnitTemperature.kelvin
                    } else if temperatureUnit == UnitTemperature.kelvin {
                        temperatureUnit = UnitTemperature.celsius
                    }
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(
                                .system(
                                    size: 30))
                        Text("Weather")
                            .font(
                                .system(
                                    size: 40,
                                    weight: .medium))
                    }
                    .padding()
                    
                    Text("Other Apple Weather data Sources")
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            if let url = URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/") {
                                UIApplication.shared.open(url)
                            }
                        }
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    SettingRootView(temperatureUnit: .celsius)
}
