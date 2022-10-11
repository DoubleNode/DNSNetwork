// swift-tools-version:5.7
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSNetwork
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSNetwork",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v10_15),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSNetwork",
            type: .static,
            targets: ["DNSNetwork"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.4"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/DoubleNodeOpen/AtomicSwift.git", from: "1.2.2"),
        .package(url: "https://github.com/DoubleNode/DNSAppCore.git", from: "1.10.0"),
        .package(url: "https://github.com/DoubleNode/DNSBaseTheme.git", from: "1.10.0"),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", from: "1.10.0"),
        .package(url: "https://github.com/DoubleNode/DNSCoreThreading.git", from: "1.10.0"),
        .package(url: "https://github.com/JanGorman/Hippolyte.git", from: "1.4.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSNetwork",
            dependencies: [
                "Alamofire", "AlamofireImage", "AtomicSwift", "DNSAppCore", "DNSBaseTheme",
                "DNSCore", "DNSCoreThreading"
            ]),
        .testTarget(
            name: "DNSNetworkTests",
            dependencies: ["DNSNetwork", "Hippolyte"],
            resources: [
                .copy("Assets/DNSGravatar.loadImage001.validImageResponse.jpg"),
                .copy("Assets/DNSGravatar.loadImage002.invalidImageResponse.jpg"),
                .copy("Assets/UIImageViewGravatar.dnsLoadGravatar001.validImageResponse.jpg")
            ]),
    ],
    swiftLanguageVersions: [.v5]
)
