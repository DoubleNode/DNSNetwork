// swift-tools-version:5.3
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
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSNetwork",
            type: .dynamic,
            targets: ["DNSNetwork"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.2"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", .exact("4.0.1")),
        .package(url: "https://github.com/MarioIannotta/AtomicSwift.git", from: "1.2.1"),
        .package(url: "https://github.com/DoubleNode/DNSAppCore.git", from: "1.1.0"),
        .package(url: "https://github.com/JanGorman/Hippolyte.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSNetwork",
            dependencies: ["Alamofire", "AlamofireImage", "AtomicSwift", "DNSAppCore"]),
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
