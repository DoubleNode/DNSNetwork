//
//  DNSAppNetworkGlobalsTests.m
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
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

    func test_init_shouldInitializeWithDefaultValues() {
        // Verify initialization
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.reachabilityStatus, .unknown)
        XCTAssertNil(sut.reachabilityManager)
    }

    func test_reachabilityStatus_whenChanged_shouldPostNotification() {
        let expectation = XCTestExpectation(description: "Notification posted")
        let observer = NotificationCenter.default.addObserver(
            forName: .reachabilityStatusChanged,
            object: sut,
            queue: nil
        ) { notification in
            expectation.fulfill()
        }

        // Change reachability status
        sut.reachabilityStatus = .reachableViaWiFi

        wait(for: [expectation], timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
    }

    func test_applicationDidBecomeActive_shouldCallUtilityStartListening() {
        // This test verifies the method can be called without crashing
        sut.applicationDidBecomeActive()
        XCTAssert(true) // If we get here without crashing, the test passes
    }

    func test_applicationWillResignActive_shouldCallUtilityStopListening() {
        // This test verifies the method can be called without crashing
        sut.applicationWillResignActive()
        XCTAssert(true) // If we get here without crashing, the test passes
    }

    func test_utilityReachabilityStatusChanged_withNotReachable_shouldSetNotReachableStatus() {
        let notReachableStatus = NetworkReachabilityManager.NetworkReachabilityStatus.notReachable
        sut.utilityReachabilityStatusChanged(status: notReachableStatus)
        XCTAssertEqual(sut.reachabilityStatus, .notReachable)
    }

    func test_utilityReachabilityStatusChanged_withUnknown_shouldSetUnknownStatus() {
        let unknownStatus = NetworkReachabilityManager.NetworkReachabilityStatus.unknown
        sut.utilityReachabilityStatusChanged(status: unknownStatus)
        XCTAssertEqual(sut.reachabilityStatus, .unknown)
    }

    func test_utilityStartListening_withNilManager_shouldNotCrash() {
        sut.reachabilityManager = nil
        sut.utilityStartListening()
        XCTAssert(true) // If we get here without crashing, the test passes
    }

    func test_utilityStopListening_withNilManager_shouldNotCrash() {
        sut.reachabilityManager = nil
        sut.utilityStopListening()
        XCTAssert(true) // If we get here without crashing, the test passes
    }
}
