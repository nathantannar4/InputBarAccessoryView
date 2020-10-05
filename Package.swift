// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InputBarAccessoryView",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "InputBarAccessoryView",
            targets: ["InputBarAccessoryView"])
    ],
    targets: [
        .target(
            name: "InputBarAccessoryView",
            path: "Sources",
            exclude: ["Supporting/Info.plist"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
