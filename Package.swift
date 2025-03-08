// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FPSwift",
    products: [
        .library(
            name: "FPSwift",
            targets: ["FPSwift"]
        ),
    ],
    targets: [
        .target(
            name: "FPSwift"),
        .testTarget(
            name: "FPSwiftTests",
            dependencies: ["FPSwift"]
        ),
    ]
)
