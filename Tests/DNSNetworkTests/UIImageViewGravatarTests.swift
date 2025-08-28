//
//  UIImageViewGravatarTests.m
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSBaseTheme
import DNSCore
import DNSCoreThreading
@preconcurrency import Hippolyte
import UIKit
import XCTest

@testable import DNSNetwork

class UIImageViewGravatarTests: XCTestCase, @unchecked Sendable {
    let baseUrl = "https://gravatar.com/avatar"
    let defaultFrame = CGRect(x: 105, y: 23, width: 55, height: 73)

    nonisolated(unsafe) private var sut: UIImageView!
    nonisolated(unsafe) private var stubManager: Hippolyte!

    override func setUp() {
        super.setUp()
        stubManager = Hippolyte.shared
        MainActor.assumeIsolated {
            sut = UIImageView()
            sut.frame = defaultFrame
        }
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

            // Call dnsLoadGravatar on MainActor
            DispatchQueue.main.async {
                self.sut.dnsLoadGravatar(for: value) { (_) in
                    stubCalled.fulfill()
                }
            }

            self.wait(for: [stubCalled], timeout: 10.0)

            // Check image on MainActor
            let expectation = self.expectation(description: "image check")
            DispatchQueue.main.async {
                XCTAssertNotNil(self.sut.image)
                expectation.fulfill()
            }
            self.wait(for: [expectation], timeout: 1.0)
        }).run()
    }
}
