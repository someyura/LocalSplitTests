// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "LocalSplitTests",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "LocalSplitTests", targets: ["LocalSplitTests"])
    ],
    targets: [
        .target(name: "LocalSplitTests", path: "Sources"),
        .testTarget(name: "LocalSplitTests-Tests", dependencies: ["LocalSplitTests"])
    ]
)