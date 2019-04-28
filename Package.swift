// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ValidationToolkit",
    products: [
        .library(name: "ValidationToolkit", targets: ["ValidationToolkit"])
    ],
    dependencies: [
     ],
    targets: [
    .target(name: "ValidationToolkit", dependencies: [], path: "Sources"),
        .testTarget(name: "ValidationToolkit.Tests", dependencies: [
            "ValidationToolkit"], path: "Tests")
    ]
)

