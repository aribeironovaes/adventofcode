// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Day5-Cafeteria",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Day5-Cafeteria",
            path: "Sources"
        )
    ]
)
