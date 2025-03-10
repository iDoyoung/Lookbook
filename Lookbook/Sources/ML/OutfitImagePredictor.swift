//MARK: Reference - https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml

import Vision
import Photos
import UIKit
import os

final class OutfitImagePredictor {
    
    private let logger = Logger(subsystem: "io.doyoung.Lookbook.OutfitImagePredictor", category: "ML")
    
    private static let imageClassifier = createImageClassifier()
    
    static func createImageClassifier() -> VNCoreMLModel {
        let defaultConfiguration = MLModelConfiguration()
        let imageClassifierWrapper = try? OutfitV1(configuration: defaultConfiguration)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifier.model) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }

    /// Generates an image classification prediction for a photo.

    func makePredictions(for data: Data) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let imageClassificationRequest = VNCoreMLRequest(model: OutfitImagePredictor.imageClassifier) { request, error in
                    guard let results = request.results as? [VNClassificationObservation],
                          let topResult = results.first else {
                        continuation.resume(returning: false)
                        return
                    }
                    if topResult.identifier == "People", topResult.confidence > 0.95 {
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(returning: false)
                    }
                }
                
                guard let image = UIImage(data: data)?.cgImage else {
                    continuation.resume(throwing: PredictorError.invalidInput)
                    return
                }
                
                let handler = VNImageRequestHandler(cgImage: image)
                
                do {
                    try handler.perform([imageClassificationRequest])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

enum PredictorError: Error {
    case invalidInput
}
