// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObservableField",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ObservableField",
            targets: ["ObservableField"]),
    ],
    targets: [
        .target(
            name: "ObservableField",
            dependencies: []),
        .testTarget(
            name: "ObservableFieldTests",
            dependencies: ["ObservableField"]),
    ]
)
