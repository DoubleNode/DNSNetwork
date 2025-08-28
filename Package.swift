// swift-tools-version:6.0
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
        .iOS(.v18),
        .tvOS(.v18),
        .macCatalyst(.v18),
        .macOS(.v15),
        .watchOS(.v11),
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
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.7.1")),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/DoubleNodeOpen/AtomicSwift.git", .upToNextMajor(from: "1.2.2")),
        .package(url: "https://github.com/DoubleNode/DNSAppCore.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/DoubleNode/DNSBaseTheme.git", .upToNextMajor(from: "2.0.1")),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", .upToNextMajor(from: "2.0.2")),
        .package(url: "https://github.com/DoubleNode/DNSCoreThreading.git", .upToNextMajor(from: "2.0.3")),
        .package(url: "https://github.com/JanGorman/Hippolyte.git", .upToNextMajor(from: "1.4.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSNetwork",
            dependencies: [
                "Alamofire", "AlamofireImage", "AtomicSwift", "DNSAppCore", "DNSBaseTheme",
                "DNSCore", "DNSCoreThreading"
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImportObjcForwardDeclarations"),
                .enableUpcomingFeature("DisableOutwardActorInference"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "DNSNetworkTests",
            dependencies: ["DNSNetwork", "Hippolyte"],
            resources: [
                .copy("Assets/DNSGravatar.loadImage001.validImageResponse.jpg"),
                .copy("Assets/DNSGravatar.loadImage002.invalidImageResponse.jpg"),
                .copy("Assets/UIImageViewGravatar.dnsLoadGravatar001.validImageResponse.jpg")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImportObjcForwardDeclarations"),
                .enableUpcomingFeature("DisableOutwardActorInference"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ],
    swiftLanguageModes: [.v5]
)
