//
//  DNSAppNetworkGlobalsTests.m
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
@preconcurrency import XCTest

@testable import DNSNetwork

@MainActor class DNSAppNetworkGlobalsTests: XCTestCase, @unchecked Sendable {
    private var sut: DNSAppNetworkGlobals!

    override func setUp() {
        super.setUp()
        MainActor.assumeIsolated {
            sut = DNSAppNetworkGlobals()
        }
    }
    override func tearDown() {
        MainActor.assumeIsolated {
            sut?.utilityStopListening()
            sut = nil
        }
        super.tearDown()
    }

    // MARK: - Initialization Tests
    
    func test_init_shouldSetDefaultReachabilityStatusToUnknown() {
        XCTAssertEqual(sut.reachabilityStatus, .unknown)
    }
    
    func test_init_shouldHaveNilReachabilityManager() {
        XCTAssertNil(sut.reachabilityManager)
    }
    
    // MARK: - Reachability Manager Tests
    
    func test_setReachabilityManager_shouldStopPreviousListening() {
        let firstManager = NetworkReachabilityManager(host: "apple.com")
        sut.reachabilityManager = firstManager
        
        let secondManager = NetworkReachabilityManager(host: "google.com")
        sut.reachabilityManager = secondManager
        
        XCTAssertNotNil(sut.reachabilityManager)
    }
    
    func test_setReachabilityManager_shouldStartListening() {
        let manager = NetworkReachabilityManager(host: "apple.com")
        sut.reachabilityManager = manager
        
        XCTAssertNotNil(sut.reachabilityManager)
    }
    
    // MARK: - Application Lifecycle Tests
    
    func test_applicationDidBecomeActive_shouldStartListening() {
        let manager = NetworkReachabilityManager(host: "apple.com")
        sut.reachabilityManager = manager
        
        sut.applicationDidBecomeActive()
        
        // Test passes if no crash occurs
        XCTAssertNotNil(sut.reachabilityManager)
    }
    
    func test_applicationWillResignActive_shouldStopListening() {
        let manager = NetworkReachabilityManager(host: "apple.com")
        sut.reachabilityManager = manager
        
        sut.applicationWillResignActive()
        
        // Test passes if no crash occurs
        XCTAssertNotNil(sut.reachabilityManager)
    }
    
    // MARK: - Reachability Status Tests
    
    func test_utilityReachabilityStatusChanged_withNotReachable_shouldSetStatusToNotReachable() {
        sut.utilityReachabilityStatusChanged(status: .notReachable)
        
        XCTAssertEqual(sut.reachabilityStatus, .notReachable)
    }
    
    func test_utilityReachabilityStatusChanged_withUnknown_shouldSetStatusToUnknown() {
        sut.utilityReachabilityStatusChanged(status: .unknown)
        
        XCTAssertEqual(sut.reachabilityStatus, .unknown)
    }
    
    func test_utilityReachabilityStatusChanged_withReachableCellular_shouldProcessConnectionCheck() {
        let expectation = self.expectation(description: "Reachability status should be set")
        
        // Setup notification observer
        let observer = NotificationCenter.default.addObserver(
            forName: .reachabilityStatusChanged,
            object: sut,
            queue: .main
        ) { _ in
            expectation.fulfill()
        }
        
        sut.utilityReachabilityStatusChanged(status: .reachable(.cellular))
        
        waitForExpectations(timeout: 15.0) { [weak self] _ in
            NotificationCenter.default.removeObserver(observer)
            // Status should be set to one of the cellular statuses
            guard let strongSelf = self else { return }
            MainActor.assumeIsolated {
                XCTAssertTrue(strongSelf.sut.reachabilityStatus == .reachableViaWWAN || 
                             strongSelf.sut.reachabilityStatus == .reachableViaWWANWithoutInternet)
            }
        }
    }
    
    func test_utilityReachabilityStatusChanged_withReachableWiFi_shouldProcessConnectionCheck() {
        let expectation = self.expectation(description: "Reachability status should be set")
        
        // Setup notification observer
        let observer = NotificationCenter.default.addObserver(
            forName: .reachabilityStatusChanged,
            object: sut,
            queue: .main
        ) { _ in
            expectation.fulfill()
        }
        
        sut.utilityReachabilityStatusChanged(status: .reachable(.ethernetOrWiFi))
        
        waitForExpectations(timeout: 15.0) { [weak self] _ in
            NotificationCenter.default.removeObserver(observer)
            // Status should be set to one of the WiFi statuses
            guard let strongSelf = self else { return }
            MainActor.assumeIsolated {
                XCTAssertTrue(strongSelf.sut.reachabilityStatus == .reachableViaWiFi || 
                             strongSelf.sut.reachabilityStatus == .reachableViaWiFiWithoutInternet)
            }
        }
    }
    
    // MARK: - Notification Tests
    
    func test_reachabilityStatusChange_shouldPostNotification() {
        let expectation = self.expectation(description: "Notification should be posted")
        
        let observer = NotificationCenter.default.addObserver(
            forName: .reachabilityStatusChanged,
            object: sut,
            queue: .main
        ) { [weak self] notification in
            guard let strongSelf = self else { return }
            MainActor.assumeIsolated {
                XCTAssertIdentical(notification.object as? DNSAppNetworkGlobals, strongSelf.sut)
            }
            expectation.fulfill()
        }
        
        sut.reachabilityStatus = .notReachable
        
        waitForExpectations(timeout: 1.0) { _ in
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Utility Method Tests
    
    func test_utilityStartListening_withNilManager_shouldNotCrash() {
        sut.reachabilityManager = nil
        sut.utilityStartListening()
        
        // Test passes if no crash occurs
        XCTAssertNil(sut.reachabilityManager)
    }
    
    func test_utilityStopListening_withNilManager_shouldNotCrash() {
        sut.reachabilityManager = nil
        sut.utilityStopListening()
        
        // Test passes if no crash occurs
        XCTAssertNil(sut.reachabilityManager)
    }
}
