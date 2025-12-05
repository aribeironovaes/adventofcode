import Foundation

/// Simple file reader utility for Advent of Code
class InputReader {
    /// Find the project root by searching up the directory tree for Package.swift
    private static func findProjectRoot() -> String {
        var currentPath = FileManager.default.currentDirectoryPath

        // Search up the directory tree for Package.swift
        while currentPath != "/" {
            let packagePath = (currentPath as NSString).appendingPathComponent("Package.swift")
            if FileManager.default.fileExists(atPath: packagePath) {
                return currentPath
            }
            currentPath = (currentPath as NSString).deletingLastPathComponent
        }

        return FileManager.default.currentDirectoryPath
    }

    /// Read a file and return its contents as a string
    /// - Parameter filename: The name of the file in the Inputs folder
    /// - Returns: The file contents as a string, or nil if reading failed
    static func readFile(from filename: String) -> String? {
        let projectRoot = findProjectRoot()

        // Try multiple possible paths
        let possiblePaths = [
            (projectRoot as NSString).appendingPathComponent("Inputs/\(filename)"),
            (FileManager.default.currentDirectoryPath as NSString).appendingPathComponent("Inputs/\(filename)"),
            "/Users/angeloribeiro/Development/adventofcode/2025/Day4-Puzzle1-Printing Department/Inputs/\(filename)"
        ]

        for path in possiblePaths {
            if let content = try? String(contentsOfFile: path, encoding: .utf8) {
                return content
            }
        }

        return nil
    }
}
