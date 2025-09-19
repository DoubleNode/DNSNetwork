//
//  UIImageViewGravatarTests.m
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import Hippolyte
import XCTest

@testable import DNSNetwork

class UIImageViewGravatarTests: XCTestCase {
    let baseUrl = "https://gravatar.com/avatar"
    let defaultFrame = CGRect(x: 105, y: 23, width: 55, height: 73)

    private var sut: UIImageView!
    private var stubManager: Hippolyte!

    override func setUp() {
        super.setUp()
        stubManager = Hippolyte.shared

        sut = UIImageView()
        sut.frame = defaultFrame
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

    func test_dnsLoadGravatar_withValidEmailAndBlock_shouldHaveValidImage() throws {
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

            self.sut.dnsLoadGravatar(for: value) { (_) in
                stubCalled.fulfill()
            }

            self.wait(for: [stubCalled], timeout: 10.0)

            XCTAssertNotNil(self.sut.image)
        }
    }

    func test_dnsLoadGravatar_withInvalidResponse_shouldCallBlockWithFalse() {
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
            var blockResult: Bool?

            self.sut.dnsLoadGravatar(for: value) { (success) in
                blockResult = success
                stubCalled.fulfill()
            }

            self.wait(for: [stubCalled], timeout: 10.0)

            XCTAssertNotNil(blockResult)
            XCTAssertFalse(blockResult!)
            XCTAssertNil(self.sut.image)
        }
    }

    func test_dnsLoadGravatar_withSquareImageView_shouldUseLargerDimension() throws {
        let squareFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        sut.frame = squareFrame

        let path = localPath(for: "DNSGravatar.loadImage001.validImageResponse.jpg")
        let data = try Data(contentsOf: path!)

        _ = DNSSynchronize {
            let response = StubResponse.Builder()
                .stubResponse(withStatusCode: 200)
                .addBody(data)
                .addHeader(withKey: "Content-Type", value: "image/jpeg")
                .build()
            // Expected URL should have size=100 (the frame size)
            let expectedUrl = "\(self.baseUrl)/1e008b5aae78e85e6775355273672735?&size=100&rating=g&default=mm"
            let request = StubRequest.Builder()
                .stubRequest(withMethod: .GET, url: URL(string: expectedUrl)!)
                .addResponse(response)
                .build()
            self.stubManager.add(stubbedRequest: request)
            self.stubManager.start()

            let stubCalled = self.expectation(description: "stub called")

            let value: String = "loadImage_withValidEmail@doublenode.com"

            self.sut.dnsLoadGravatar(for: value) { (success) in
                stubCalled.fulfill()
            }

            self.wait(for: [stubCalled], timeout: 10.0)

            XCTAssertNotNil(self.sut.image)
        }
    }

    func test_dnsLoadGravatar_withWiderImageView_shouldUseWidth() throws {
        let wideFrame = CGRect(x: 0, y: 0, width: 200, height: 100)
        sut.frame = wideFrame

        let path = localPath(for: "DNSGravatar.loadImage001.validImageResponse.jpg")
        let data = try Data(contentsOf: path!)

        _ = DNSSynchronize {
            let response = StubResponse.Builder()
                .stubResponse(withStatusCode: 200)
                .addBody(data)
                .addHeader(withKey: "Content-Type", value: "image/jpeg")
                .build()
            // Expected URL should have size=200 (the width since it's larger)
            let expectedUrl = "\(self.baseUrl)/1e008b5aae78e85e6775355273672735?&size=200&rating=g&default=mm"
            let request = StubRequest.Builder()
                .stubRequest(withMethod: .GET, url: URL(string: expectedUrl)!)
                .addResponse(response)
                .build()
            self.stubManager.add(stubbedRequest: request)
            self.stubManager.start()

            let stubCalled = self.expectation(description: "stub called")

            let value: String = "loadImage_withValidEmail@doublenode.com"

            self.sut.dnsLoadGravatar(for: value) { (success) in
                stubCalled.fulfill()
            }

            self.wait(for: [stubCalled], timeout: 10.0)

            XCTAssertNotNil(self.sut.image)
        }
    }

    func test_dnsLoadGravatar_withNilBlock_shouldNotCrash() {
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

            let value: String = "loadImage_withNetworkDown@doublenode.com"

            // Call with nil block - should not crash
            self.sut.dnsLoadGravatar(for: value, then: nil)

            // Give it a moment to complete
            Thread.sleep(forTimeInterval: 0.5)

            XCTAssert(true) // If we get here without crashing, the test passes
        }
    }
}
