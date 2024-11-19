import XCTest
import Photos
@testable import Lookbook

final class PhotosWorkerTests: XCTestCase {
   
    var sut: PhotosWorker!
    var state: PhotosState!
    var mockPhotosService: MockPhotosService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPhotosService = MockPhotosService()
        sut = PhotosWorker(service: mockPhotosService)
        state = PhotosState()
    }
    
    override func tearDownWithError() throws {
        state = nil
        mockPhotosService = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Test Doubles
    
    class MockPhotosService: PhotosServiceProtocol {
        
        var auth: PHAuthorizationStatus!
        //FIXME: - Need to mock PHAsset
        var assets: [PHAsset] = []
        var isCallAuthorization: Bool = false
        var isCallFetchResult: Bool = false
       
        func authorizationStatus() async -> PHAuthorizationStatus {
            isCallAuthorization = true
            return auth
        }
        
        func fetchResult(mediaType: Lookbook.PhotosService.MediaType, albumType: Lookbook.PhotosService.AlbumType?, dateRange: (startDate: Date, endDate: Date)?) -> PHFetchResult<PHAsset> {
            isCallFetchResult = true
            
            return MockPHFetchResult(assets: assets)
        }
    }
    
    class MockPHFetchResult: PHFetchResult<PHAsset>, @unchecked Sendable {
        private var mockAssets: [PHAsset]
        
        init(assets: [PHAsset]) {
            self.mockAssets = assets
            super.init()
        }
        
        override var count: Int {
            return mockAssets.count
        }
    }
    
    // MARK: - Tests
    
    func test_requestAuthorization_souldBeUpdateStateToMockAuthWithCallPhotoService() async {
        
        // given
        mockPhotosService.auth = .authorized
        
        // when
        let pHAuthorizationStatus = await sut.requestAuthorizationStatus()
        
        // then
        XCTAssertEqual(pHAuthorizationStatus, .authorized)
        XCTAssertTrue(mockPhotosService.isCallAuthorization)
    }
    
    func test_fetchPhotosAssets_shouldBeCallPhotosService() async {
        
        // given
        
        // when
        let fetchResult = await sut.fetchPhotosAssets()
        
        // then
        XCTAssertTrue(mockPhotosService.isCallFetchResult)
    }
}
