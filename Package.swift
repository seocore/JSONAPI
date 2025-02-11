// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JSONAPIKit",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "JSONAPIKit",
            targets: ["JSONAPIKit"]),
        .library(
            name: "JSONAPITesting",
            targets: ["JSONAPITesting"])
    ],
    dependencies: [
        .package(url: "https://github.com/seocore/Poly.git", .branch("main")),
    ],
    targets: [
        .target(
            name: "JSONAPIKit",
            dependencies: ["Poly"]),
        .target(
            name: "JSONAPITesting",
            dependencies: ["JSONAPIKit"]),
        .testTarget(
            name: "JSONAPITests",
            dependencies: ["JSONAPIKit", "JSONAPITesting"]),
        .testTarget(
            name: "JSONAPITestingTests",
            dependencies: ["JSONAPIKit", "JSONAPITesting"])
    ],
    swiftLanguageVersions: [.v5]
)
