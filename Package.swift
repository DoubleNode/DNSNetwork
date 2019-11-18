// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
            targets: ["DNSNetwork"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0-rc.3"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.0.0-beta.6"),
        .package(url: "https://github.com/MarioIannotta/AtomicSwift.git", from: "1.0.0"),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", from: "1.0.0"),
        .package(url: "https://github.com/JanGorman/Hippolyte.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSNetwork",
            dependencies: ["Alamofire", "AlamofireImage", "AtomicSwift", "DNSCore"]),
        .testTarget(
            name: "DNSNetworkTests",
            dependencies: ["DNSNetwork", "Hippolyte"]),
    ]
)
