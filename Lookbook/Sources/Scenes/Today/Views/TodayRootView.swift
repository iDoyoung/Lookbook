import SwiftUI
import Photos

struct TodayRootView: View {
    
    @State var model: TodayModel
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    TodayWeatherView(model: model)
                        .containerRelativeFrame(.vertical)
                        .scrollTransition(
                            axis: .vertical
                        ) { content, phase in
                            content
                                .offset(y: phase.value * -300)
                        }
                    
                    ForEach(model.outfitPhotos, id: \.id) { photo in
                        WeatherOutfitView(
                            photoAsset: photo.asset,
                            location: (model.locationState.location, photo.location),
                            date: photo.creationDate,
                            lowTemperature: photo.lowTemp,
                            highTemperature: photo.highTemp
                        )
                        .scrollTransition(
                            axis: .vertical
                        ) { content, phase in
                            content
                                .offset(y: phase.value > 0 ? phase.value : phase.value * -300)
                        }
                        .containerRelativeFrame(.vertical)
                        .clipShape(Rectangle())
                        .shadow(radius: 10)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
        }
        .ignoresSafeArea()
    }
}
