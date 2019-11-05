import XCTest

import DNSNetworkTests

var tests = [XCTestCaseEntry]()
tests += DNSNetworkTests.allTests()
XCTMain(tests)
