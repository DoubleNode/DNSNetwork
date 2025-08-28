//
//  DNSSessionManagerTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import Foundation
import XCTest

@testable import DNSNetwork

class DNSSessionManagerTests: XCTestCase {
    private var mockDelegate: MockSessionManagerDelegate!
    
    override func setUp() {
        super.setUp()
        mockDelegate = MockSessionManagerDelegate()
    }
    
    override func tearDown() {
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Protocol Tests
    
    func test_protocol_shouldDefineSuccessMethod() {
        let response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockDelegate.success(with: response, and: ["key": "value"])
        
        XCTAssertTrue(mockDelegate.successCalled)
        XCTAssertEqual(mockDelegate.lastHttpResponse?.statusCode, 200)
        XCTAssertNotNil(mockDelegate.lastResponseObject)
    }
    
    func test_protocol_shouldDefineServerErrorMethod() {
        let response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockDelegate.serverError(with: response, and: ["error": "Server Error"])
        
        XCTAssertTrue(mockDelegate.serverErrorCalled)
        XCTAssertEqual(mockDelegate.lastHttpResponse?.statusCode, 500)
        XCTAssertNotNil(mockDelegate.lastResponseObject)
    }
    
    func test_protocol_shouldDefineDataErrorMethod() {
        let errorData = "Error data".data(using: .utf8)!
        let errorMessage = "Test error message"
        
        mockDelegate.dataError(with: errorData, and: errorMessage)
        
        XCTAssertTrue(mockDelegate.dataErrorCalled)
        XCTAssertEqual(mockDelegate.lastErrorData, errorData)
        XCTAssertEqual(mockDelegate.lastErrorMessage, errorMessage)
    }
    
    func test_protocol_shouldDefineUnknownErrorMethod() {
        let error = NSError(domain: "TestDomain", code: 999, userInfo: nil)
        
        mockDelegate.unknownError(with: error)
        
        XCTAssertTrue(mockDelegate.unknownErrorCalled)
        XCTAssertEqual((mockDelegate.lastError as NSError?)?.code, 999)
    }
    
    func test_protocol_shouldDefineNoResponseErrorMethod() {
        mockDelegate.noResponseError()
        
        XCTAssertTrue(mockDelegate.noResponseErrorCalled)
    }
}

// MARK: - Mock Classes

class MockSessionManagerDelegate: DNSSessionManagerProtocol {
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

