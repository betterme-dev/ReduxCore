// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReduxCore",
    platforms: [
     .iOS(.v11),
     .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "ReduxCore",
            type: .dynamic,
            targets: ["ReduxCore"]
        )
    ],
    targets: [
        .target(
            name: "ReduxCore",
            path: "ReduxCore/Sources"
        ),
        .testTarget(
            name: "ReduxCoreTests",
            dependencies: ["ReduxCore"],
            path: "ReduxCore/Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
