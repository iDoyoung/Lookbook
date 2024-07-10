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
final class ImagePredictor {
    
    private let logger = Logger()
    
    /// The function signature the caller must provide as a completion handler.
    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void
    
    /// Stores a classification name and confidence for an image classifier's prediction.
    struct Prediction {
        /// The name of the object or scene the image classifier recognizes in an image.
        let classification: String
        
        /// The image classifier's confidence as a percentage string.
        ///
        /// The prediction string doesn't include the % symbol in the string.
        let confidencePercentage: Int
    }
    
    private static let imageClassifier = createImageClassifier()
    
    /// A dictionary of prediction handler functions, each keyed by its Vision request.
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
    
    
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
    
    /// Generates a new request instance that uses the Image Predictor's image classifier model.
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        // Create an image classification request with an image classifier model.

        let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.imageClassifier) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                fatalError("Unexpected results type from VNCoreMLRequest")
            }
            
            self?.logger.log("\(topResult.identifier) in \(results.count)")
            
        }
        
        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }
    
    /// Generates an image classification prediction for a photo.
    /// - Parameter photo: An image, typically of an object or a scene.
    /// - Tag: makePredictions
    func makePredictions(for photo: CGImage) throws {
        let imageClassificationRequest = createImageClassificationRequest()
        let handler = VNImageRequestHandler(cgImage: photo)
        let requests: [VNRequest] = [imageClassificationRequest]

        // Start the image classification request.
        try handler.perform(requests)
    }
}

let request = VNCoreMLRequest(model: model) { (request, error) in
    guard let results = request.results as? [VNClassificationObservation],
          let topResult = results.first else {
        print("분류 결과를 가져올 수 없습니다.")
        return
    }
    
    // 분류 결과 확인
    print("분류 결과: \(topResult.identifier), 확률: \(topResult.confidence)")
    
    // 분류 결과가 1인 경우에 대한 조건 추가
    if topResult.identifier == "1" && topResult.confidence >= 0.7 {
        // 1로 분류되고 확률이 70% 이상일 때 true를 리턴
        DispatchQueue.main.async {
            return true
        }
    } else {
        // 그 외의 경우에는 false를 리턴
        DispatchQueue.main.async {
            return false
        }
    }
}
