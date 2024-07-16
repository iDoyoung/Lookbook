//MARK: Reference - https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml

import Vision
import UIKit
import os

/// A convenience class that makes image classification predictions.
///
/// The Image Predictor creates and reuses an instance of a Core ML image classifier inside a ``VNCoreMLRequest``.
/// Each time it makes a prediction, the class:
/// - Creates a `VNImageRequestHandler` with an image
/// - Starts an image classification request for that image
/// - Converts the prediction results in a completion handler
/// - Updates the delegate's `predictions` property
final class OutfitImagePredictor {
    
    private let logger = Logger(subsystem: "io.doyoung.Lookbook.OutfitImagePredictor", category: "ML")
   
    private static let imageClassifier = createImageClassifier()
    
    static func createImageClassifier() -> VNCoreMLModel {
        let defaultConfiguration = MLModelConfiguration()

        // Create an instance of the image classifier's wrapper class.
        let imageClassifierWrapper = try? OutfitV1(configuration: defaultConfiguration)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        // Get the underlying model instance.
        let imageClassifierModel = imageClassifier.model

        // Create a Vision instance using the image classifier's model instance.
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }
   
    /// Generates an image classification prediction for a photo.
    /// - Parameter photo: An image, typically of an object or a scene.
    /// - Tag: makePredictions
    func makePredictions(for data: Data, completion: @escaping (Bool) -> Void) {
        
        let imageClassificationRequest = VNCoreMLRequest(model: OutfitImagePredictor.imageClassifier) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion(false)
                return
            }
            if topResult.identifier == "People", topResult.confidence > 0.9 {
                completion(true)
            }
        }
        
        guard let image = UIImage(data: data)?.cgImage else { return }
        
        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        let handler = VNImageRequestHandler(cgImage: image)
        let requests: [VNRequest] = [imageClassificationRequest]

        // Start the image classification request.
        do {
            try handler.perform(requests)
        } catch let error {
            logger.error("Vision Request performing Error: \(error)")
            completion(false)
        }
    }
}
