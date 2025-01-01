// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "PaperMC",
    platforms: [
        .macOS(.v13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4),
        .visionOS(.v1),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PaperMCAPI",
            targets: ["PaperMCAPI"]),
        .library(
            name: "HangarAPI",
            targets: ["HangarAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.6.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.7.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession.git", from: "1.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PaperMCAPI",
            dependencies: [
                "Common",
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ]
        ),
        .testTarget(
            name: "PaperMCAPITests",
            dependencies: ["PaperMCAPI"]
        ),
        .target(
            name: "HangarAPI",
            dependencies: [
                "Common",
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ]
        ),
        .testTarget(
            name: "HangarAPITests",
            dependencies: ["HangarAPI"]
        ),
        .target(name: "Common", dependencies: [.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime")])
    ]
)
