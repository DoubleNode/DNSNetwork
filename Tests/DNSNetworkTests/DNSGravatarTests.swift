//
//  DNSGravatarTests.m
//  DNSCoreTests
//
//  Created by Darren Ehlers on 10/23/16.
//  Copyright © 2019 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import Hippolyte
import XCTest

@testable import DNSNetwork

class DNSGravatarTests: XCTestCase {
    let baseUrl = "https://gravatar.com/avatar"

    private var sut: DNSGravatar!
    private var stubManager: Hippolyte!

    override func setUp() {
        super.setUp()
        stubManager = Hippolyte.shared

        sut = DNSGravatar()
    }
    override func tearDown() {
        sut = nil

        stubManager.stop()
        stubManager = nil
        super.tearDown()
    }

    private func localPath(for filename: String) -> URL? {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let localPathURL = thisDirectory.appendingPathComponent("Assets/\(filename)")

        return localPathURL
    }

    func test_gravatarUrl_withStringNil_shouldReturnDefaultUrlWithRatingGAndDefaultTypeMM() {
        let value: String? = nil
        sut.email = value
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/00000000000000000000000000000000?&rating=g&default=mm"))
    }
    func test_gravatarUrl_withInvalidEmail_shouldReturnUrlWithRatingGAndDefaultTypeMM() {
        let value: String? = "noone@doublenode"
        sut.email = value
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ddc00e1d0ed6df4527d567f48993093e?&rating=g&default=mm"))
    }
    func test_gravatarUrl_withNonexistingEmail_shouldReturnUrlWithRatingGAndDefaultTypeMM() {
        let value: String? = "noone@doublenode.com"
        sut.email = value
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/4e9e53a52910c100d15bce1067f4f6d2?&rating=g&default=mm"))
    }
    func test_gravatarUrl_withValidEmail_shouldReturnUrlWithRatingGAndDefaultTypeMM() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=g&default=mm"))
    }
    func test_gravatarUrl_withValidEmailAndSize_shouldReturnUrlWithSize220AndRatingGAndDefaultTypeMM() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.size = 220
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&size=220&rating=g&default=mm"))
    }
    func test_gravatarUrl_withValidEmailAndRating_shouldReturnUrlWithRatingRAndDefaultTypeMM() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.rating = .r
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=r&default=mm"))
    }
    func test_gravatarUrl_withValidEmailAndDefaultType_shouldReturnUrlWithRatingGAndDefaultType404() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.defaultType = .none404
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=g&default=404"))
    }
    func test_gravatarUrl_withValidEmailAndDefaultType_shouldReturnUrlWithRatingGAndDefaultTypeIdenticon() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.defaultType = .identicon
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=g&default=identicon"))
    }
    func test_gravatarUrl_withValidEmailAndDefaultType_shouldReturnUrlWithRatingGAndDefaultTypeMonsterId() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.defaultType = .monsterId
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=g&default=monsterid"))
    }
    func test_gravatarUrl_withValidEmailAndDefaultType_shouldReturnUrlWithRatingGAndDefaultTypeWavatar() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.defaultType = .wavatar
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=g&default=wavatar"))
    }
    func test_gravatarUrl_withValidEmailAndDefaultType_shouldReturnUrlWithRatingGAndDefaultTypeRetro() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.defaultType = .retro
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=g&default=retro"))
    }
    func test_gravatarUrl_withValidEmailAndDefaultType_shouldReturnUrlWithRatingGAndDefaultTypeBlank() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.defaultType = .blank
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=g&default=blank"))
    }
    func test_gravatarUrl_withValidEmailAndForceDefault_shouldReturnUrlWithRatingGAndDefaultTypeBlank() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.forceDefault = true
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result,
                       URL(string: "\(baseUrl)/ffafcbd840bdba1e12bad6606fffce86?&rating=g&default=mm&forcedefault=y"))
    }
    func test_loadImage_withValidEmail_shouldHaveValidImage() throws {
        let path = localPath(for: "DNSGravatar.loadImage001.validImageResponse.jpg")
        let data = try Data(contentsOf: path!)

        _ = DNSSynchronize {
            let response = StubResponse.Builder()
                .stubResponse(withStatusCode: 200)
                .addBody(data)
                .addHeader(withKey: "Content-Type", value: "image/jpeg")
                .build()
            let expectedUrl = "\(self.baseUrl)/1e008b5aae78e85e6775355273672735?&rating=g&default=mm"
            let request = StubRequest.Builder()
                .stubRequest(withMethod: .GET, url: URL(string: expectedUrl)!)
                .addResponse(response)
                .build()
            self.stubManager.add(stubbedRequest: request)
            self.stubManager.start()

            let stubCalled = self.expectation(description: "stub called")

            let value: String = "loadImage_withValidEmail@doublenode.com"
            self.sut.email = value

            var result: UIImage?

            self.sut.loadImage { (image) in
                result = image
                stubCalled.fulfill()
            }
            self.wait(for: [stubCalled], timeout: 10.0)

            XCTAssertNotNil(result)
        }
    }

    func test_loadImage_withInvalidResponse_shouldNotHaveValidImage() throws {
        let path = localPath(for: "DNSGravatar.loadImage002.invalidImageResponse.jpg")
        let data = try Data(contentsOf: path!)

        _ = DNSSynchronize {
            let response = StubResponse.Builder()
                .stubResponse(withStatusCode: 200)
                .addBody(data)
                .addHeader(withKey: "Content-Type", value: "image/jpeg")
                .build()
            let expectedUrl = "\(self.baseUrl)/7afd84d916e10bcc7e023a05d71b6b34?&rating=g&default=mm"
            let request = StubRequest.Builder()
                .stubRequest(withMethod: .GET, url: URL(string: expectedUrl)!)
                .addResponse(response)
                .build()
            self.stubManager.add(stubbedRequest: request)
            self.stubManager.start()

            let stubCalled = self.expectation(description: "stub called")

            let value: String = "loadImage_withInvalidResponse@doublenode.com"
            self.sut.email = value

            var result: UIImage?

            self.sut.loadImage { (image) in
                result = image
                stubCalled.fulfill()
            }
            self.wait(for: [stubCalled], timeout: 10.0)
            XCTAssertNil(result)
        }
    }

    func test_loadImage_withNetworkDown_shouldNotHaveValidImage() {
        _ = DNSSynchronize {
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            let response = StubResponse.Builder()
                .stubResponse(withError: notConnectedError)
                .build()
            let expectedUrl = "\(self.baseUrl)/0df804d5321babe6bbfb41defed6d31e?&rating=g&default=mm"
            let request = StubRequest.Builder()
                .stubRequest(withMethod: .GET, url: URL(string: expectedUrl)!)
                .addResponse(response)
                .build()
            self.stubManager.add(stubbedRequest: request)
            self.stubManager.start()

            let stubCalled = self.expectation(description: "stub called")

            let value: String = "loadImage_withNetworkDown@doublenode.com"
            self.sut.email = value

            var result: UIImage?

            self.sut.loadImage { (image) in
                result = image
                stubCalled.fulfill()
            }
            self.wait(for: [stubCalled], timeout: 10.0)

            XCTAssertNil(result)
        }
    }
}
