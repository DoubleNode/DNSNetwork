//
//  DNSAppNetworkGlobalsTests.m
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest

@testable import DNSNetwork

class DNSAppNetworkGlobalsTests: XCTestCase {
    private var sut: DNSAppNetworkGlobals!

    override func setUp() {
        super.setUp()
        sut = DNSAppNetworkGlobals()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_zero() {
        XCTFail("Tests not yet implemented in DNSAppNetworkGlobalsTests")
    }
}
