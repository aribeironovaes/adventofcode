// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Day6-Trash-Compactor",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Day6-Trash-Compactor",
            path: "Sources"
        )
    ]
)
