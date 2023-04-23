// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "TBIconTransitionKit",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "TBIconTransitionKit",
            targets: ["TBIconTransitionKit"]),
    ],
    targets: [
        .target(
            name: "TBIconTransitionKit",
            path: "Sources"),
    ]
)
