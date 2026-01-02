#!/usr/bin/env swift

import Foundation

let inputPath = "test_part2.txt"

guard let content = try? String(contentsOfFile: inputPath, encoding: .utf8) else {
    print("Failed to read input file")
    exit(1)
}

// Parse the graph
var graph: [String: [String]] = [:]

for line in content.split(separator: "\n") {
    let parts = line.split(separator: ":")
    guard parts.count == 2 else { continue }

    let device = String(parts[0].trimmingCharacters(in: .whitespaces))
    let outputs = parts[1]
        .split(separator: " ")
        .map { String($0.trimmingCharacters(in: .whitespaces)) }
        .filter { !$0.isEmpty }

    graph[device] = outputs
}

// Count paths that visit all required nodes
func countPathsWithRequired(
    from: String,
    to: String,
    visited: Set<String>,
    requiredVisited: Set<String>,
    requiredNodes: Set<String>
) -> Int {
    // Update required nodes tracking
    var newRequiredVisited = requiredVisited
    if requiredNodes.contains(from) {
        newRequiredVisited.insert(from)
    }

    // Base case: reached destination
    if from == to {
        // Only count if all required nodes were visited
        return newRequiredVisited == requiredNodes ? 1 : 0
    }

    // Get neighbors
    guard let neighbors = graph[from] else {
        return 0
    }

    var totalPaths = 0
    var currentVisited = visited
    currentVisited.insert(from)

    // Explore each neighbor
    for neighbor in neighbors {
        // Avoid cycles
        if !currentVisited.contains(neighbor) {
            totalPaths += countPathsWithRequired(
                from: neighbor,
                to: to,
                visited: currentVisited,
                requiredVisited: newRequiredVisited,
                requiredNodes: requiredNodes
            )
        }
    }

    return totalPaths
}

// Count paths from "svr" to "out" that visit both "dac" and "fft"
let pathCount = countPathsWithRequired(
    from: "svr",
    to: "out",
    visited: [],
    requiredVisited: [],
    requiredNodes: ["dac", "fft"]
)

print("Paths from 'svr' to 'out' visiting 'dac' and 'fft': \(pathCount)")
print("Expected: 2")
