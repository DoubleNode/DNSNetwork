//
//  DNSNetworkPerformanceTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSNetworkTests
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSAppCore
import DNSCore
import XCTest

@testable import DNSNetwork

class DNSNetworkPerformanceTests: XCTestCase {
    
    // MARK: - DNSGravatar Performance Tests
    
    func testPerformance_DNSGravatar_urlGeneration() {
        let gravatar = DNSGravatar()
        gravatar.email = "performance@test.com"
        gravatar.size = 200
        gravatar.rating = .pg
        gravatar.defaultType = .identicon
        gravatar.forceDefault = true
        
        measure {
            for _ in 0..<1000 {
                _ = gravatar.gravatarUrl
            }
        }
    }
    
    func testPerformance_DNSGravatar_initialization() {
        measure {
            for _ in 0..<1000 {
                let gravatar = DNSGravatar()
                gravatar.email = "test@example.com"
                _ = gravatar.gravatarUrl
            }
        }
    }
    
    func testPerformance_DNSGravatar_urlGenerationWithVariousEmails() {
        let emails = [
            "user1@example.com",
            "user2@test.org",
            "user3@domain.co.uk",
            "user4@website.net",
            "user5@company.io"
        ]
        
        measure {
            for email in emails {
                for _ in 0..<200 {
                    let gravatar = DNSGravatar()
                    gravatar.email = email
                    _ = gravatar.gravatarUrl
                }
            }
        }
    }
    
    func testPerformance_DNSGravatar_complexUrlGeneration() {
        measure {
            for i in 0..<500 {
                let gravatar = DNSGravatar()
                gravatar.email = "user\(i)@performance.test"
                gravatar.size = UInt(50 + (i % 450)) // Vary size from 50 to 500
                gravatar.rating = [.g, .pg, .r, .x][i % 4]
                gravatar.defaultType = [.mysteryMan, .identicon, .monsterId, .wavatar, .retro, .blank][i % 6]
                gravatar.forceDefault = (i % 2 == 0)
                _ = gravatar.gravatarUrl
            }
        }
    }
    
    // MARK: - DNSAppNetworkGlobals Performance Tests
    
    func testPerformance_DNSAppNetworkGlobals_initialization() {
        measure {
            for _ in 0..<100 {
                let globals = DNSAppNetworkGlobals()
                _ = globals.reachabilityStatus
            }
        }
    }
    
    func testPerformance_DNSAppNetworkGlobals_reachabilityStatusChanges() {
        let globals = DNSAppNetworkGlobals()
        
        measure {
            for i in 0..<1000 {
                let statuses: [C.AppGlobals.ReachabilityStatus] = [
                    .unknown, .notReachable, .reachableViaWiFi, 
                    .reachableViaWWAN, .reachableViaWiFiWithoutInternet,
                    .reachableViaWWANWithoutInternet
                ]
                globals.reachabilityStatus = statuses[i % statuses.count]
            }
        }
    }
    
    // MARK: - DNSNetworkCodeLocation Performance Tests
    
    func testPerformance_DNSNetworkCodeLocation_initialization() {
        measure {
            for _ in 0..<1000 {
                _ = DNSNetworkCodeLocation("test")
            }
        }
    }
    
    func testPerformance_DNSNetworkCodeLocation_domainPrefaceAccess() {
        measure {
            for _ in 0..<1000 {
                _ = DNSNetworkCodeLocation.domainPreface
            }
        }
    }
    
    // MARK: - Memory Performance Tests
    
    func testMemoryPerformance_DNSGravatar_multipleInstances() {
        measure {
            var gravatars: [DNSGravatar] = []
            for i in 0..<100 {
                let gravatar = DNSGravatar()
                gravatar.email = "memory\(i)@test.com"
                gravatar.size = UInt(100 + i)
                gravatars.append(gravatar)
            }
            // Clear references
            gravatars.removeAll()
        }
    }
    
    func testMemoryPerformance_DNSAppNetworkGlobals_multipleInstances() {
        measure {
            var globals: [DNSAppNetworkGlobals] = []
            for _ in 0..<50 {
                let global = DNSAppNetworkGlobals()
                globals.append(global)
            }
            // Clear references
            globals.removeAll()
        }
    }
    
    // MARK: - Concurrent Performance Tests
    
    func testPerformance_DNSGravatar_concurrentUrlGeneration() {
        let gravatar = DNSGravatar()
        gravatar.email = "concurrent@test.com"
        
        measure {
            let group = DispatchGroup()
            let concurrentQueue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)
            
            for _ in 0..<100 {
                group.enter()
                concurrentQueue.async {
                    for _ in 0..<10 {
                        _ = gravatar.gravatarUrl
                    }
                    group.leave()
                }
            }
            group.wait()
        }
    }
    
    func testPerformance_DNSNetworkCodeLocation_concurrentAccess() {
        measure {
            let group = DispatchGroup()
            let concurrentQueue = DispatchQueue(label: "com.test.concurrent.code", attributes: .concurrent)
            
            for _ in 0..<100 {
                group.enter()
                concurrentQueue.async {
                    for _ in 0..<10 {
                        _ = DNSNetworkCodeLocation.domainPreface
                        _ = DNSNetworkCodeLocation("test")
                    }
                    group.leave()
                }
            }
            group.wait()
        }
    }
}