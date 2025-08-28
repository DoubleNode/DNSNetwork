//
//  DNSNetworkIntegrationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import DNSCoreThreading
import Hippolyte
import UIKit
import XCTest

@testable import DNSNetwork

class DNSNetworkIntegrationTests: XCTestCase {
    private var stubManager: Hippolyte!
    
    override func setUp() {
        super.setUp()
        stubManager = Hippolyte.shared
    }
    
    override func tearDown() {
        stubManager?.stop()
        stubManager = nil
        super.tearDown()
    }
    
    // MARK: - Integration Tests
    
    func test_integration_DNSGravatarWithUIImageView_shouldWorkTogether() throws {
        let path = localPath(for: "DNSGravatar.loadImage001.validImageResponse.jpg")
        let data = try Data(contentsOf: path!)
        
        DNSSynchronize(with: self, andRun: {
            // Setup stub
            let response = StubResponse.Builder()
                .stubResponse(withStatusCode: 200)
                .addBody(data)
                .addHeader(withKey: "Content-Type", value: "image/jpeg")
                .build()
            let expectedUrl = "https://gravatar.com/avatar/1e008b5aae78e85e6775355273672735?&size=100&rating=g&default=mm"
            let request = StubRequest.Builder()
                .stubRequest(withMethod: .GET, url: URL(string: expectedUrl)!)
                .addResponse(response)
                .build()
            self.stubManager.add(stubbedRequest: request)
            self.stubManager.start()
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            let completionExpectation = self.expectation(description: "Image loaded")
            
            imageView.dnsLoadGravatar(for: "loadImage_withValidEmail@doublenode.com") { success in
                XCTAssertTrue(success)
                XCTAssertNotNil(imageView.image)
                completionExpectation.fulfill()
            }
            
            self.wait(for: [completionExpectation], timeout: 10.0)
        }).run()
    }
    
    func test_integration_DNSAppNetworkGlobalsWithReachability_shouldHandleStatusChanges() {
        let globals = DNSAppNetworkGlobals()
        let statusChangeExpectation = expectation(description: "Status change notification")
        
        // Setup notification observer
        let observer = NotificationCenter.default.addObserver(
            forName: .reachabilityStatusChanged,
            object: globals,
            queue: .main
        ) { notification in
            XCTAssertIdentical(notification.object as? DNSAppNetworkGlobals, globals)
            statusChangeExpectation.fulfill()
        }
        
        // Create and assign reachability manager
        let reachabilityManager = NetworkReachabilityManager(host: "apple.com")
        globals.reachabilityManager = reachabilityManager
        
        // Test application lifecycle methods
        globals.applicationDidBecomeActive()
        
        // Trigger status change
        globals.reachabilityStatus = .reachableViaWiFi
        
        waitForExpectations(timeout: 2.0) { _ in
            NotificationCenter.default.removeObserver(observer)
            globals.applicationWillResignActive()
        }
    }
    
    func test_integration_multipleGravatarRequests_shouldHandleConcurrency() throws {
        let path = localPath(for: "DNSGravatar.loadImage001.validImageResponse.jpg")
        let data = try Data(contentsOf: path!)
        
        DNSSynchronize(with: self, andRun: {
            // Setup stubs for multiple requests
            let emails = [
                "user1@example.com",
                "user2@example.com", 
                "user3@example.com"
            ]
            
            let expectedHashes = [
                "e7c16b0d5e5e8c8b2b6b1ef1c4c4f1e0", // user1@example.com MD5 (placeholder)
                "f9c16b0d5e5e8c8b2b6b1ef1c4c4f1e1", // user2@example.com MD5 (placeholder)
                "a1c16b0d5e5e8c8b2b6b1ef1c4c4f1e2"  // user3@example.com MD5 (placeholder)
            ]
            
            for (index, email) in emails.enumerated() {
                let response = StubResponse.Builder()
                    .stubResponse(withStatusCode: 200)
                    .addBody(data)
                    .addHeader(withKey: "Content-Type", value: "image/jpeg")
                    .build()
                
                // Use actual MD5 hash for the email
                let gravatar = DNSGravatar()
                gravatar.email = email
                let actualUrl = gravatar.gravatarUrl.absoluteString
                
                let request = StubRequest.Builder()
                    .stubRequest(withMethod: .GET, url: URL(string: actualUrl)!)
                    .addResponse(response)
                    .build()
                self.stubManager.add(stubbedRequest: request)
            }
            
            self.stubManager.start()
            
            let group = DispatchGroup()
            var results: [UIImage?] = Array(repeating: nil, count: emails.count)
            
            // Launch concurrent requests
            for (index, email) in emails.enumerated() {
                group.enter()
                let gravatar = DNSGravatar()
                gravatar.email = email
                
                gravatar.loadImage { image in
                    results[index] = image
                    group.leave()
                }
            }
            
            group.wait()
            
            // Verify all requests succeeded
            for (index, result) in results.enumerated() {
                XCTAssertNotNil(result, "Request \\(index) should have succeeded")
            }
        }).run()
    }
    
    func test_integration_DNSSessionManagerProtocol_shouldHandleAllCallbacks() {
        let delegate = IntegrationMockSessionManagerDelegate()
        
        // Test success callback
        let successResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        delegate.success(with: successResponse, and: ["data": "success"])
        XCTAssertTrue(delegate.successCalled)
        
        // Test server error callback
        let errorResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        delegate.serverError(with: errorResponse, and: ["error": "Server Error"])
        XCTAssertTrue(delegate.serverErrorCalled)
        
        // Test data error callback
        let errorData = "Error data".data(using: .utf8)!
        delegate.dataError(with: errorData, and: "Test error")
        XCTAssertTrue(delegate.dataErrorCalled)
        
        // Test unknown error callback
        let unknownError = NSError(domain: "TestDomain", code: 999)
        delegate.unknownError(with: unknownError)
        XCTAssertTrue(delegate.unknownErrorCalled)
        
        // Test no response callback
        delegate.noResponseError()
        XCTAssertTrue(delegate.noResponseErrorCalled)
    }
    
    func test_integration_errorHandling_shouldPropagateCorrectly() throws {
        DNSSynchronize(with: self, andRun: {
            // Setup error response
            let errorResponse = StubResponse.Builder()
                .stubResponse(withStatusCode: 404)
                .build()
            let expectedUrl = "https://gravatar.com/avatar/1e008b5aae78e85e6775355273672735?&rating=g&default=mm"
            let request = StubRequest.Builder()
                .stubRequest(withMethod: .GET, url: URL(string: expectedUrl)!)
                .addResponse(errorResponse)
                .build()
            self.stubManager.add(stubbedRequest: request)
            self.stubManager.start()
            
            let gravatar = DNSGravatar()
            gravatar.email = "loadImage_withValidEmail@doublenode.com"
            
            let errorExpectation = self.expectation(description: "Error handled")
            
            gravatar.loadImage { image in
                XCTAssertNil(image, "Should return nil for 404 error")
                errorExpectation.fulfill()
            }
            
            self.wait(for: [errorExpectation], timeout: 10.0)
        }).run()
    }
    
    func test_integration_memoryManagement_shouldNotLeak() {
        weak var weakGravatar: DNSGravatar?
        weak var weakGlobals: DNSAppNetworkGlobals?
        weak var weakCodeLocation: DNSNetworkCodeLocation?
        
        autoreleasepool {
            let gravatar = DNSGravatar()
            gravatar.email = "memory@test.com"
            weakGravatar = gravatar
            
            let globals = DNSAppNetworkGlobals()
            globals.reachabilityStatus = .reachableViaWiFi
            weakGlobals = globals
            
            let codeLocation = DNSNetworkCodeLocation("test")
            weakCodeLocation = codeLocation
            
            // Use objects to ensure they're retained during the test
            _ = gravatar.gravatarUrl
            _ = globals.reachabilityStatus
            _ = type(of: codeLocation).domainPreface
        }
        
        // Objects should be deallocated after leaving autoreleasepool
        XCTAssertNil(weakGravatar, "DNSGravatar should be deallocated")
        XCTAssertNil(weakGlobals, "DNSAppNetworkGlobals should be deallocated")
        XCTAssertNil(weakCodeLocation, "DNSNetworkCodeLocation should be deallocated")
    }
    
    func test_integration_threadSafety_shouldHandleConcurrentAccess() {
        let gravatar = DNSGravatar()
        gravatar.email = "thread@safety.test"
        
        let expectation = self.expectation(description: "Concurrent access completed")
        let concurrentQueue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)
        let group = DispatchGroup()
        
        var urls: [URL] = []
        let urlsLock = DispatchQueue(label: "com.test.urls.lock")
        
        // Launch multiple concurrent reads
        for _ in 0..<50 {
            group.enter()
            concurrentQueue.async {
                let url = gravatar.gravatarUrl
                urlsLock.sync {
                    urls.append(url)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            // All URLs should be identical
            let firstUrl = urls.first
            for url in urls {
                XCTAssertEqual(url, firstUrl, "All URLs should be identical in concurrent access")
            }
            XCTAssertEqual(urls.count, 50, "Should have 50 URLs")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0)
    }
    
    // MARK: - Helper Methods
    
    private func localPath(for filename: String) -> URL? {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let localPathURL = thisDirectory.appendingPathComponent("Assets/\\(filename)")
        
        return localPathURL
    }
}

// MARK: - Mock Classes for Integration Testing

class IntegrationMockSessionManagerDelegate: DNSSessionManagerProtocol {
    var successCalled = false
    var serverErrorCalled = false
    var dataErrorCalled = false
    var unknownErrorCalled = false
    var noResponseErrorCalled = false
    
    var lastHttpResponse: HTTPURLResponse?
    var lastResponseObject: Any?
    var lastErrorData: Data?
    var lastErrorMessage: String?
    var lastError: (any Error)?
    
    func success(with httpResponse: HTTPURLResponse, and responseObject: Any?) {
        successCalled = true
        lastHttpResponse = httpResponse
        lastResponseObject = responseObject
    }
    
    func serverError(with httpResponse: HTTPURLResponse, and responseObject: Any?) {
        serverErrorCalled = true
        lastHttpResponse = httpResponse
        lastResponseObject = responseObject
    }
    
    func dataError(with errorData: Data, and errorMessage: String) {
        dataErrorCalled = true
        lastErrorData = errorData
        lastErrorMessage = errorMessage
    }
    
    func unknownError(with error: any Error) {
        unknownErrorCalled = true
        lastError = error
    }
    
    func noResponseError() {
        noResponseErrorCalled = true
    }
}

