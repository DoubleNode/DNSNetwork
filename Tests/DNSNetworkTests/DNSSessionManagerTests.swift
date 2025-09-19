//
//  DNSSessionManagerTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest

@testable import DNSNetwork

class DNSSessionManagerTests: XCTestCase {

    // Mock implementation for testing protocol conformance
    class MockSessionManager: DNSSessionManagerProtocol {
        var successCalled = false
        var serverErrorCalled = false
        var dataErrorCalled = false
        var unknownErrorCalled = false
        var noResponseErrorCalled = false

        var lastHttpResponse: HTTPURLResponse?
        var lastResponseObject: Any?
        var lastErrorData: Data?
        var lastErrorMessage: String?
        var lastError: Error?

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

        func unknownError(with error: Error) {
            unknownErrorCalled = true
            lastError = error
        }

        func noResponseError() {
            noResponseErrorCalled = true
        }
    }

    private var sut: MockSessionManager!

    override func setUp() {
        super.setUp()
        sut = MockSessionManager()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_success_shouldSetCorrectFlags() {
        let url = URL(string: "https://example.com")!
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let responseObject = ["key": "value"]

        sut.success(with: httpResponse, and: responseObject)

        XCTAssertTrue(sut.successCalled)
        XCTAssertNotNil(sut.lastHttpResponse)
        XCTAssertEqual(sut.lastHttpResponse?.statusCode, 200)
        XCTAssertNotNil(sut.lastResponseObject)
    }

    func test_serverError_shouldSetCorrectFlags() {
        let url = URL(string: "https://example.com")!
        let httpResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        let responseObject = ["error": "Server error"]

        sut.serverError(with: httpResponse, and: responseObject)

        XCTAssertTrue(sut.serverErrorCalled)
        XCTAssertNotNil(sut.lastHttpResponse)
        XCTAssertEqual(sut.lastHttpResponse?.statusCode, 500)
        XCTAssertNotNil(sut.lastResponseObject)
    }

    func test_dataError_shouldSetCorrectFlags() {
        let errorData = "Error data".data(using: .utf8)!
        let errorMessage = "Test error message"

        sut.dataError(with: errorData, and: errorMessage)

        XCTAssertTrue(sut.dataErrorCalled)
        XCTAssertNotNil(sut.lastErrorData)
        XCTAssertEqual(sut.lastErrorMessage, errorMessage)
        XCTAssertEqual(sut.lastErrorData, errorData)
    }

    func test_unknownError_shouldSetCorrectFlags() {
        let error = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])

        sut.unknownError(with: error)

        XCTAssertTrue(sut.unknownErrorCalled)
        XCTAssertNotNil(sut.lastError)
        XCTAssertEqual((sut.lastError as NSError?)?.code, 123)
        XCTAssertEqual((sut.lastError as NSError?)?.domain, "TestDomain")
    }

    func test_noResponseError_shouldSetCorrectFlags() {
        sut.noResponseError()

        XCTAssertTrue(sut.noResponseErrorCalled)
    }

    func test_protocolConformance_shouldImplementAllRequiredMethods() {
        // This test verifies that our mock implements all required protocol methods
        XCTAssertTrue(sut is DNSSessionManagerProtocol)

        // Verify all methods can be called without compilation errors
        let url = URL(string: "https://example.com")!
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        sut.success(with: httpResponse, and: nil)
        sut.serverError(with: httpResponse, and: nil)
        sut.dataError(with: Data(), and: "")
        sut.unknownError(with: NSError(domain: "", code: 0, userInfo: nil))
        sut.noResponseError()

        XCTAssert(true) // If we get here, all methods are implemented
    }
}