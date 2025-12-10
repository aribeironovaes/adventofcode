import Foundation

// MARK: - Advent of Code 2025 - Day 9: Movie Theater
//
// Problem Overview:
// ===============
// Find the largest rectangle using red tiles as opposite corners.
// Given a list of red tile coordinates, calculate the maximum area
// of any rectangle formed by choosing two tiles as opposite corners.

print("=== Advent of Code 2025 - Day 9: Movie Theater ===\n")

// Read inputs
let sampleInput = InputReader.readFile(from: "sample.txt")
let actualInput = InputReader.readFile(from: "input.txt")

// MARK: - Part 1: Largest Rectangle

print("--- Part 1: Largest Rectangle ---\n")

// Test with sample
print("Testing with sample input...")
if let content = sampleInput, let finder = TileRectangleFinder(from: content) {
    let result = finder.findLargestRectangleArea()
    print("Sample result: \(result)")
    print("Expected: 50")
    print(result == 50 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not parse sample.txt\n")
}

// Solve Part 1
print("Solving Part 1...")
if let content = actualInput, let finder = TileRectangleFinder(from: content) {
    let result = finder.findLargestRectangleArea()
    print("Part 1 Answer: \(result)")
    print("\nLargest rectangle area: \(result)")
} else {
    print("Could not parse input.txt")
}

// MARK: - Part 2: Rectangle with Only Red/Green Tiles

print("\n--- Part 2: Rectangle with Red/Green Tiles ---\n")

// Test with sample
print("Testing with sample input...")
if let content = sampleInput, let finder = TileRectangleFinder(from: content) {
    let result = finder.findLargestRectangleWithGreen()
    print("Sample result: \(result)")
    print("Expected: 24")
    print(result == 24 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not parse sample.txt\n")
}

// Solve Part 2
print("Solving Part 2...")
if let content = actualInput, let finder = TileRectangleFinder(from: content) {
    let result = finder.findLargestRectangleWithGreen()
    print("Part 2 Answer: \(result)")
    print("\nLargest rectangle with red/green tiles: \(result)")
} else {
    print("Could not parse input.txt")
}
