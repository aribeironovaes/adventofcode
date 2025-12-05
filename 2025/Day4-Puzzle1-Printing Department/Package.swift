// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Day4-Printing-Department",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Day4-Printing-Department",
            path: "Sources"
        )
    ]
)
