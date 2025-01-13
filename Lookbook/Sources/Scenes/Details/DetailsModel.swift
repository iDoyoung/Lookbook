import Foundation
import UIKit
import Photos

@Observable
final class DetailsModel {
    var phAsset: PHAsset? {
        didSet {
            Task {
                imageData = await phAsset?.data()
            }
        }
    }
    
    var imageData: Data?
    var date: Date? { phAsset?.creationDate }
    var maximuTemperature: Double?
    var minimumTemperature: Double?
    var location = ""
}
