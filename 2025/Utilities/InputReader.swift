import Foundation

/// Utility class for reading and parsing rotation input
struct InputReader {

    /// Read rotations from a file
    /// - Parameter filename: The name of the input file
    /// - Returns: Array of Rotation objects
    static func readRotations(from filename: String) -> [Rotation] {
        // Find the project root by looking for Package.swift
        let projectRoot = findProjectRoot()

        // Try multiple possible locations for the Inputs folder
        var possiblePaths = [
            // When run from project root
            "Inputs/\(filename)",
            // When run from build directory (swift run)
            "../../../Inputs/\(filename)",
        ]

        // If we found the project root, add that path
        if let root = projectRoot {
            possiblePaths.insert("\(root)/Inputs/\(filename)", at: 0)
        }

        // Also try current directory
        possiblePaths.append(FileManager.default.currentDirectoryPath + "/Inputs/\(filename)")

        var contents: String?

        for path in possiblePaths {
            if let fileContents = try? String(contentsOfFile: path, encoding: .utf8) {
                contents = fileContents
                break
            }
        }

        guard let fileContents = contents else {
            print("Error: Could not read file '\(filename)'")
            print("Tried the following locations:")
            for path in possiblePaths {
                print("  - \(path)")
            }
            print("\nCurrent directory: \(FileManager.default.currentDirectoryPath)")
            return []
        }

        return parseRotations(from: fileContents)
    }

    /// Find the project root by searching for Package.swift
    private static func findProjectRoot() -> String? {
        let fileManager = FileManager.default
        var currentPath = fileManager.currentDirectoryPath

        // Search up the directory tree for Package.swift
        for _ in 0..<10 {  // Limit search depth
            let packagePath = (currentPath as NSString).appendingPathComponent("Package.swift")
            if fileManager.fileExists(atPath: packagePath) {
                return currentPath
            }

            // Go up one directory
            let parentPath = (currentPath as NSString).deletingLastPathComponent
            if parentPath == currentPath {
                break  // Reached root
            }
            currentPath = parentPath
        }

        // Alternative: Check common Xcode source locations
        let possibleRoots = [
            "/Users/angeloribeiro/Development/adventofcode/2025/Day1-Puzzle1-Secret Entrance",
            fileManager.currentDirectoryPath.replacingOccurrences(of: "/Library/Developer/Xcode/DerivedData.*", with: "", options: .regularExpression)
        ]

        for root in possibleRoots {
            let packagePath = (root as NSString).appendingPathComponent("Package.swift")
            if fileManager.fileExists(atPath: packagePath) {
                return root
            }
        }

        return nil
    }

    /// Parse rotations from a string
    /// - Parameter string: The input string containing rotation instructions
    /// - Returns: Array of Rotation objects
    static func parseRotations(from string: String) -> [Rotation] {
        return string
            .components(separatedBy: .newlines)
            .compactMap { Rotation(from: $0) }
    }
}
