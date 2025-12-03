// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SecretEntrance",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "SecretEntrance",
            path: "Sources"
        )
    ]
)
