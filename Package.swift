// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftBlogCarnival",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "SiteGenerator",
            dependencies: [
                "Yams",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/SiteGenerator"
        ),
    ]
)
