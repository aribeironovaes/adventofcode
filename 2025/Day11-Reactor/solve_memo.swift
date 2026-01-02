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

// Memoization key: (current node, set of required nodes visited so far)
struct MemoKey: Hashable {
    let node: String
    let requiredVisited: Set<String>
}

// Count paths with memoization
func countPathsWithMemo(
    from: String,
    to: String,
    visited: Set<String>,
    requiredVisited: Set<String>,
    requiredNodes: Set<String>,
    memo: inout [MemoKey: Int]
) -> Int {
    // Update required nodes tracking
    var newRequiredVisited = requiredVisited
    if requiredNodes.contains(from) {
        newRequiredVisited.insert(from)
    }

    // Base case: reached destination
    if from == to {
        return newRequiredVisited == requiredNodes ? 1 : 0
    }

    // Check memo
    let key = MemoKey(node: from, requiredVisited: newRequiredVisited)
    if let cached = memo[key] {
        return cached
    }

    // Get neighbors
    guard let neighbors = graph[from] else {
        memo[key] = 0
        return 0
    }

    var totalPaths = 0
    var currentVisited = visited
    currentVisited.insert(from)

    // Explore each neighbor
    for neighbor in neighbors {
        // Avoid cycles
        if !currentVisited.contains(neighbor) {
            totalPaths += countPathsWithMemo(
                from: neighbor,
                to: to,
                visited: currentVisited,
                requiredVisited: newRequiredVisited,
                requiredNodes: requiredNodes,
                memo: &memo
            )
        }
    }

    memo[key] = totalPaths
    return totalPaths
}

// Part 1: Count all paths from "you" to "out"
var memo1: [MemoKey: Int] = [:]
let part1Count = countPathsWithMemo(
    from: "you",
    to: "out",
    visited: [],
    requiredVisited: [],
    requiredNodes: [],
    memo: &memo1
)

// Part 2: Count paths from "svr" to "out" that visit both "dac" and "fft"
var memo2: [MemoKey: Int] = [:]
let part2Count = countPathsWithMemo(
    from: "svr",
    to: "out",
    visited: [],
    requiredVisited: [],
    requiredNodes: ["dac", "fft"],
    memo: &memo2
)

print("Part 1 - Paths from 'you' to 'out': \(part1Count)")
print("Part 2 - Paths from 'svr' to 'out' visiting 'dac' and 'fft': \(part2Count)")
