// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AsposeBarcodeCloud",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "AsposeBarcodeCloud",
            targets: ["AsposeBarcodeCloud"]
        ),
        .executable(
            name: "GenerateAndScanExample",
            targets: ["GenerateAndScanExample"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Flight-School/AnyCodable", .upToNextMajor(from: "0.6.1")),
    ],
    targets: [
        .target(
            name: "AsposeBarcodeCloud",
            dependencies: ["AnyCodable"],
            path: "Sources/AsposeBarcodeCloud"
        ),
        .target(
            name: "GenerateAndScanExample",
            dependencies: ["AsposeBarcodeCloud"],
            path: "Examples/GenerateAndScan"
        ),
        .testTarget(
            name: "AsposeBarcodeCloudTests",
            dependencies: ["AsposeBarcodeCloud"],
            path: "Tests/AsposeBarcodeCloudTests"
        ),
    ]
)
