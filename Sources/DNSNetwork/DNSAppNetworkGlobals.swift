//
//  DNSAppNetworkGlobals.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSNetwork
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
@preconcurrency import AtomicSwift
import DNSAppCore
import DNSCore
import DNSCoreThreading
import Foundation
import SystemConfiguration.CaptiveNetwork

public class DNSAppNetworkGlobals: DNSAppGlobals, @unchecked Sendable {

    var reachabilityManager: NetworkReachabilityManager? { // NetworkReachabilityManager(host: "apple.com")
        willSet {
            self.utilityStopListening()
        }
        didSet {
            self.utilityStartListening()
        }
    }
    var reachabilityStatus: C.AppGlobals.ReachabilityStatus = .unknown {
        didSet {
            NotificationCenter.default.post(name: .reachabilityStatusChanged, object: self)
        }
    }

    // MARK: - Application methods

    override public func applicationDidBecomeActive() {
        self.utilityStartListening()
        super.applicationDidBecomeActive()
    }
    override public func applicationWillResignActive() {
        super.applicationWillResignActive()
        self.utilityStopListening()
    }

    // MARK: - Utility methods

    func utilityStartListening() {
        // swiftlint:disable:next line_length
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] (status: NetworkReachabilityManager.NetworkReachabilityStatus) in
            self?.utilityReachabilityStatusChanged(status: status)
        })
    }
    func utilityStopListening() {
        reachabilityManager?.stopListening()
    }
    func utilityReachabilityStatusChanged(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
        case .notReachable:
            reachabilityStatus = .notReachable
        case .unknown:
            reachabilityStatus = .unknown
        case .reachable(.cellular), .reachable(.ethernetOrWiFi):
            let successCount = Atomic<Int>(wrappedValue: 0)
            let checkDomains = [ "www.apple.com", "apple.com", "www.appleiphonecell.com" ]

            _ = DNSThreadingGroup.run(block: { threadingGroup in
                for domain: String in checkDomains {
                    let thread = DNSThread { thread in
                        _ = URLSessionConfiguration.default
                        let url = URL(string: "https://\(domain)/library/test/success.html")
                        guard url != nil else {
                            thread.done()
                            return
                        }
                        AF.request(url!).validate().responseString { response in
                            switch response.result {
                            case .failure:
                                thread.done()
                            case .success:
                                successCount.wrappedValue += 1
                                thread.done()
                            }
                        }
                    }
                    threadingGroup.run(thread)
                }
            }, then: { [weak self] (_) in
                let successPercent  = (successCount.wrappedValue / checkDomains.count) * 100
                let withoutInternet = successPercent > 75
                if status == .reachable(.cellular) {
                    self?.reachabilityStatus = (withoutInternet ? .reachableViaWWANWithoutInternet : .reachableViaWWAN)
                } else if status == .reachable(.ethernetOrWiFi) {
                    self?.reachabilityStatus = (withoutInternet ? .reachableViaWiFiWithoutInternet : .reachableViaWiFi)
                }
            })
        }
    }
}
