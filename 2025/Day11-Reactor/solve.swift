#!/usr/bin/env swift

import Foundation

let inputPath = "/Users/angeloribeiro/Development/adventofcode/inputDay11.txt"

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

// Count all paths from "you" to "out" using DFS
func countPaths(from: String, to: String, visited: Set<String>) -> Int {
    // Base case: reached destination
    if from == to {
        return 1
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
            totalPaths += countPaths(from: neighbor, to: to, visited: currentVisited)
        }
    }

    return totalPaths
}

let pathCount = countPaths(from: "you", to: "out", visited: [])

print("Number of paths from 'you' to 'out': \(pathCount)")
