//
//  imageFeedApplicationTests.swift
//  imageFeedApplicationTests
//
//  Created by Илья Тимченко on 16.03.2023.
//

@testable import imageFeedApplication
import XCTest

final class ImagesListServiceTests: XCTestCase {

    func testImageListService() throws {
        let service = ImagesListService()
        let expectation = expectation(description: "Image List Service Expectation")
        NotificationCenter.default.addObserver(forName: ImagesListService.notification, object: nil, queue: .main) { notification in
            expectation.fulfill()
        }
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(service.photos.count, 5)
    }
    
}
