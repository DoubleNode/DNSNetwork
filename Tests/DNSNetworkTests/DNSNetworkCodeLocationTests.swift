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

    func test_domainPreface_shouldReturnCorrectValue() {
        let result = DNSNetworkCodeLocation.domainPreface
        XCTAssertEqual(result, "com.doublenode.network.")
    }

    func test_typealiasAccess_shouldWorkCorrectly() {
        let codeLocation = DNSCodeLocation.network("test")
        XCTAssertNotNil(codeLocation)
        XCTAssertTrue(codeLocation is DNSNetworkCodeLocation)
    }

    func test_inheritance_shouldInheritFromDNSCodeLocation() {
        XCTAssertTrue(sut is DNSCodeLocation)
    }

    func test_init_shouldCreateValidInstance() {
        XCTAssertNotNil(sut)
        XCTAssertTrue(type(of: sut) == DNSNetworkCodeLocation.self)
    }
}