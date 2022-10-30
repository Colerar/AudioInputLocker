// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudioInputLocker",
    dependencies: [
        .package(url: "https://github.com/rnine/SimplyCoreAudio.git", from: "4.1.0"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "AudioInputLocker",
            dependencies: ["SimplyCoreAudio", "SwiftCLI"]
        ),
    ]
)
