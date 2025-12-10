import Foundation

// MARK: - Advent of Code 2025 - Day 8: Playground
//
// Problem Overview:
// ===============
// Connect junction boxes in 3D space using shortest connections.
// Use Union-Find to track connected components (circuits).
// After making N shortest connections, find product of three largest circuits.

print("=== Advent of Code 2025 - Day 8: Playground ===\n")

// Read inputs
let sampleInput = InputReader.readFile(from: "sample.txt")
let actualInput = InputReader.readFile(from: "input.txt")

// MARK: - Part 1: Connect Shortest Pairs

print("--- Part 1: Connect Shortest Junction Boxes ---\n")

// Test with sample (10 connections)
print("Testing with sample input...")
if let content = sampleInput, let network = JunctionBoxNetwork(from: content) {
    let result = network.connectShortestEdges(10)
    print("Sample result: \(result)")
    print("Expected: 40")
    print(result == 40 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not parse sample.txt\n")
}

// Solve Part 1 (1000 connections)
print("Solving Part 1...")
if let content = actualInput, let network = JunctionBoxNetwork(from: content) {
    let result = network.connectShortestEdges(1000)
    print("Part 1 Answer: \(result)")
    print("\nProduct of three largest circuits: \(result)")
} else {
    print("Could not parse input.txt")
}
