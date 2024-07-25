//
//  PhotosServiceTests.swift
//  LookbookTests
//
//  Created by Doyoung on 7/1/24.
//

import XCTest
@testable import Lookbook

final class PhotosServiceTests: XCTestCase {

    var sut: PhotosService?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PhotosService()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
}
