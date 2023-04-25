// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sauron",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Sauron",
            targets: ["Sauron"]),
    ],
    targets: [
        .target(
            name: "Sauron",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SauronTests",
            dependencies: ["Sauron"]
        ),
    ]
)
