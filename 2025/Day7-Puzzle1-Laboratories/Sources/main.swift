import Foundation

// MARK: - Advent of Code 2025 - Day 7: Laboratories
//
// Problem Overview:
// ===============
// Simulate tachyon beams in a manifold with splitters.
// Beams move downward and split when they hit a splitter (^).
// When a beam hits a splitter, it stops and creates two new beams
// going left and right from the splitter position.
// Count the total number of times beams are split.

print("=== Advent of Code 2025 - Day 7: Laboratories ===\n")

// Read inputs
let sampleInput = InputReader.readFile(from: "sample.txt")
let actualInput = InputReader.readFile(from: "input.txt")

// MARK: - Part 1: Count Beam Splits

print("--- Part 1: Count Beam Splits ---\n")

// Test with sample
print("Testing with sample input...")
if let content = sampleInput, let manifold = TachyonManifold(from: content) {
    let result = manifold.countSplits()
    print("Sample result: \(result)")
    print("Expected: 21")
    print(result == 21 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not parse sample.txt\n")
}

// Solve Part 1
print("Solving Part 1...")
if let content = actualInput, let manifold = TachyonManifold(from: content) {
    let result = manifold.countSplits()
    print("Part 1 Answer: \(result)")
    print("\nTotal beam splits: \(result)")
} else {
    print("Could not parse input.txt")
}

// MARK: - Part 2: Quantum Timelines

print("\n--- Part 2: Quantum Timelines ---\n")

// Test with sample
print("Testing with sample input...")
if let content = sampleInput, let manifold = TachyonManifold(from: content) {
    let result = manifold.countQuantumTimelines()
    print("Sample result: \(result)")
    print("Expected: 40")
    print(result == 40 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not parse sample.txt\n")
}

// Solve Part 2
print("Solving Part 2...")
if let content = actualInput, let manifold = TachyonManifold(from: content) {
    let result = manifold.countQuantumTimelines()
    print("Part 2 Answer: \(result)")
    print("\nTotal quantum timelines: \(result)")
} else {
    print("Could not parse input.txt")
}
