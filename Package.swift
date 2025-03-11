// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudioInputLocker",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "AudioInputLocker", targets: ["AudioInputLocker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/rnine/SimplyCoreAudio.git", from: "4.1.1"),
        .package(name: "LaunchAtLogin", url: "https://github.com/sindresorhus/LaunchAtLogin-Modern.git", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "AudioInputLocker",
            dependencies: ["SimplyCoreAudio", "LaunchAtLogin"]
        ),
    ]
)
