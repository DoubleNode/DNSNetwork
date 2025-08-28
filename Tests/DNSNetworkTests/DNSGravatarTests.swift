//
//  DNSGravatarTests.m
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
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
        XCTAssertEqual(result, URL(string: "\(baseUrl)/65059343d34109c04c54d6e9fb54737eed14d3e0f6d0c53b268a8bbb69fcdc2d?&rating=g&default=mm"))
    }
    func test_gravatarUrl_withNonexistingEmail_shouldReturnUrlWithRatingGAndDefaultTypeMM() {
        let value: String? = "noone@doublenode.com"
        sut.email = value
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/3cca6291448c472717d6bf39a55f2f8a532a9327dd91ed4901bba09db6351242?&rating=g&default=mm"))
    }
    func test_gravatarUrl_withValidEmail_shouldReturnUrlWithRatingGAndDefaultTypeMM() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/3dc2cecf71de73763d5f58aa72b8663a38794e732c2be9012769e3ce7c5a8d0b?&rating=g&default=mm"))
    }
    func test_gravatarUrl_withValidEmailAndSize_shouldReturnUrlWithSize220AndRatingGAndDefaultTypeMM() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.size = 220
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/3dc2cecf71de73763d5f58aa72b8663a38794e732c2be9012769e3ce7c5a8d0b?&size=220&rating=g&default=mm"))
    }
    func test_gravatarUrl_withValidEmailAndRating_shouldReturnUrlWithRatingRAndDefaultTypeMM() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.rating = .r
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)/3dc2cecf71de73763d5f58aa72b8663a38794e732c2be9012769e3ce7c5a8d0b?&rating=r&default=mm"))
    }
    func test_gravatarUrl_withValidEmailAndDefaultType_shouldReturnUrlWithRatingGAndDefaultType404() {
        let value: String? = "test@doublenode.com"
        sut.email = value
        sut.defaultType = .none404
        let result: URL? = sut!.gravatarUrl
        XCTAssertEqual(result, URL(string: "\(baseUrl)///gravatar.com/avatar/3dc2cecf71de73763d5f58aa72b8663a38794e732c2be9012769e3ce7c5a8d0b?&rating=g&default=404"))
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

        DNSSynchronize(with: self, andRun: {
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
        }).run()
    }

    func test_loadImage_withInvalidResponse_shouldNotHaveValidImage() throws {
        let path = localPath(for: "DNSGravatar.loadImage002.invalidImageResponse.jpg")
        let data = try Data(contentsOf: path!)

        DNSSynchronize(with: self, andRun: {
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
        }).run()
    }

    func test_loadImage_withNetworkDown_shouldNotHaveValidImage() {
        DNSSynchronize(with: self, andRun: {
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
        }).run()
    }
    
    // MARK: - Additional Comprehensive Tests
    
    func test_initialization_shouldHaveDefaultValues() {
        XCTAssertNil(sut.email)
        XCTAssertNil(sut.size)
        XCTAssertEqual(sut.rating, .g)
        XCTAssertEqual(sut.defaultType, .mysteryMan)
        XCTAssertFalse(sut.forceDefault)
    }
    
    func test_baseUrl_shouldBeCorrect() {
        XCTAssertEqual(sut.baseUrl, "https://gravatar.com/avatar")
    }
    
    func test_rating_allCases_shouldGenerateCorrectUrls() {
        sut.email = "test@example.com"
        
        // Test all rating cases
        sut.rating = .g
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&rating=g"))
        
        sut.rating = .pg
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&rating=pg"))
        
        sut.rating = .r
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&rating=r"))
        
        sut.rating = .x
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&rating=x"))
    }
    
    func test_defaultType_allCases_shouldGenerateCorrectUrls() {
        sut.email = "test@example.com"
        
        sut.defaultType = .none404
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&default=404"))
        
        sut.defaultType = .mysteryMan
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&default=mm"))
        
        sut.defaultType = .identicon
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&default=identicon"))
        
        sut.defaultType = .monsterId
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&default=monsterid"))
        
        sut.defaultType = .wavatar
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&default=wavatar"))
        
        sut.defaultType = .retro
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&default=retro"))
        
        sut.defaultType = .blank
        XCTAssertTrue(sut.gravatarUrl.absoluteString.contains("&default=blank"))
    }
    
    func test_size_variousSizes_shouldGenerateCorrectUrls() {
        sut.email = "test@example.com"
        
        // Test various sizes
        let testSizes: [UInt] = [1, 50, 80, 100, 200, 512, 2048]
        
        for size in testSizes {
            sut.size = size
            let url = sut.gravatarUrl.absoluteString
            XCTAssertTrue(url.contains("&size=\(size)"), "URL should contain size=\(size)")
        }
    }
    
    func test_size_nilValue_shouldNotIncludeSizeParameter() {
        sut.email = "test@example.com"
        sut.size = nil
        
        let url = sut.gravatarUrl.absoluteString
        XCTAssertFalse(url.contains("&size="))
    }
    
    func test_forceDefault_true_shouldIncludeForceDefaultParameter() {
        sut.email = "test@example.com"
        sut.forceDefault = true
        
        let url = sut.gravatarUrl.absoluteString
        XCTAssertTrue(url.contains("&forcedefault=y"))
    }
    
    func test_forceDefault_false_shouldNotIncludeForceDefaultParameter() {
        sut.email = "test@example.com"
        sut.forceDefault = false
        
        let url = sut.gravatarUrl.absoluteString
        XCTAssertFalse(url.contains("&forcedefault="))
    }
    
    func test_complexConfiguration_shouldGenerateCorrectUrl() {
        sut.email = "complex@test.com"
        sut.size = 256
        sut.rating = .pg
        sut.defaultType = .identicon
        sut.forceDefault = true
        
        let url = sut.gravatarUrl.absoluteString
        
        XCTAssertTrue(url.contains("&size=256"))
        XCTAssertTrue(url.contains("&rating=pg"))
        XCTAssertTrue(url.contains("&default=identicon"))
        XCTAssertTrue(url.contains("&forcedefault=y"))
    }
    
    func test_loadImage_withNilBlock_shouldNotCrash() {
        sut.email = "test@example.com"
        
        // This should not crash even with nil block
        sut.loadImage(block: nil)
        
        // Test passes if no crash occurs
        XCTAssertNotNil(sut)
    }
    
    func test_loadImage_withEmptyEmail_shouldUseDefaultHash() {
        sut.email = ""
        
        let url = sut.gravatarUrl
        // Empty string MD5 hash
        XCTAssertTrue(url.absoluteString.contains("/d41d8cd98f00b204e9800998ecf8427e?"))
    }
    
    func test_generateUrl_consistency_shouldAlwaysReturnSameUrlForSameInput() {
        sut.email = "consistency@test.com"
        sut.size = 100
        sut.rating = .r
        sut.defaultType = .retro
        
        let url1 = sut.gravatarUrl
        let url2 = sut.gravatarUrl
        
        XCTAssertEqual(url1, url2)
    }
    
    func test_loadImage_with404Response_shouldReturnNil() throws {
        DNSSynchronize(with: self, andRun: {
            let response = StubResponse.Builder()
                .stubResponse(withStatusCode: 404)
                .build()
            let expectedUrl = "\(self.baseUrl)/1e008b5aae78e85e6775355273672735?&rating=g&default=mm"
            let request = StubRequest.Builder()
                .stubRequest(withMethod: .GET, url: URL(string: expectedUrl)!)
                .addResponse(response)
                .build()
            self.stubManager.add(stubbedRequest: request)
            self.stubManager.start()

            let stubCalled = self.expectation(description: "stub called")

            self.sut.email = "loadImage_withValidEmail@doublenode.com"

            var result: UIImage?

            self.sut.loadImage { (image) in
                result = image
                stubCalled.fulfill()
            }
            self.wait(for: [stubCalled], timeout: 10.0)

            XCTAssertNil(result)
        }).run()
    }
}
