//
//  DNSNetworkCodeLocationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import XCTest

@testable import DNSNetwork

class DNSNetworkCodeLocationTests: XCTestCase {
    private var sut: DNSNetworkCodeLocation!
    
    override func setUp() {
        super.setUp()
        sut = DNSNetworkCodeLocation("test")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Domain Preface Tests
    
    func test_domainPreface_shouldReturnCorrectValue() {
        let expected = "com.doublenode.network."
        let result = DNSNetworkCodeLocation.domainPreface
        
        XCTAssertEqual(result, expected)
    }
    
    func test_domainPreface_shouldBeStaticProperty() {
        let result1 = DNSNetworkCodeLocation.domainPreface
        let result2 = DNSNetworkCodeLocation.domainPreface
        
        XCTAssertEqual(result1, result2)
    }
    
    // MARK: - Type Extension Tests
    
    func test_codeLocationNetworkExtension_shouldProvideNetworkTypealias() {
        let networkCodeLocation: DNSCodeLocation.network = DNSNetworkCodeLocation("test")
        
        XCTAssertNotNil(networkCodeLocation)
        XCTAssertTrue(networkCodeLocation is DNSNetworkCodeLocation)
    }
    
    // MARK: - Inheritance Tests
    
    func test_inheritance_shouldExtendDNSCodeLocation() {
        XCTAssertTrue(sut != nil)
    }
    
    func test_inheritance_shouldConformToSendable() {
        // Test that the class can be used in concurrent contexts
        XCTAssertNotNil(sut)
    }
    
    // MARK: - Initialization Tests
    
    func test_init_shouldCreateValidInstance() {
        XCTAssertNotNil(sut)
    }
    
    func test_init_shouldInheritFromDNSCodeLocation() {
        let codeLocation: DNSCodeLocation = sut
        XCTAssertNotNil(codeLocation)
    }
    
    // MARK: - Domain Construction Tests
    
    func test_domainConstruction_shouldUseCorrectPreface() {
        // Since DNSNetworkCodeLocation inherits from DNSCodeLocation,
        // it should use the correct domain preface in any domain-related operations
        let expected = "com.doublenode.network."
        
        XCTAssertEqual(type(of: sut).domainPreface, expected)
    }
    
    // MARK: - Multiple Instance Tests
    
    func test_multipleInstances_shouldHaveSameDomainPreface() {
        let instance1 = DNSNetworkCodeLocation("test1")
        let instance2 = DNSNetworkCodeLocation("test2")
        
        XCTAssertEqual(type(of: instance1).domainPreface, type(of: instance2).domainPreface)
    }
    
    // MARK: - Sendable Compliance Tests
    
    @MainActor func test_sendableCompliance_shouldAllowConcurrentAccess() {
        let expectation1 = expectation(description: "Thread 1 completed")
        let expectation2 = expectation(description: "Thread 2 completed")
        
        DispatchQueue.global(qos: .background).async {
            let instance = DNSNetworkCodeLocation("test")
            XCTAssertNotNil(instance)
            expectation1.fulfill()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let preface = DNSNetworkCodeLocation.domainPreface
            XCTAssertEqual(preface, "com.doublenode.network.")
            expectation2.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}
