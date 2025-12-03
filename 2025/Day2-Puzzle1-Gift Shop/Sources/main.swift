import Foundation

// MARK: - Advent of Code 2025 - Day 2 Part 1: Gift Shop
//
// Problem Overview:
// ===============
// Find invalid product IDs in given ranges. An invalid ID is one where
// a sequence of digits is repeated exactly twice.
//
// Examples of invalid IDs:
// - 55 (5 repeated twice)
// - 6464 (64 repeated twice)
// - 123123 (123 repeated twice)
//
// For each range, find all invalid IDs and sum them up.

print("=== Advent of Code 2025 - Day 2 Part 1: Gift Shop ===\n")

// Test with sample input
print("Testing with sample input...")
let sampleInput = InputReader.readFile(from: "sample.txt")

if let sampleContent = sampleInput {
    let sampleRanges = GiftShop.parseRanges(from: sampleContent)
    print("Found \(sampleRanges.count) ranges to process")

    let sampleResult = GiftShop.processRanges(sampleRanges)
    print("Sample result: \(sampleResult)")
    print("Expected: 1227775554")
    print(sampleResult == 1227775554 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not read sample.txt\n")
}

// Solve the actual puzzle
print("Solving the actual puzzle...")
let input = InputReader.readFile(from: "input.txt")

if let content = input {
    let ranges = GiftShop.parseRanges(from: content)
    print("Found \(ranges.count) ranges to process")
    print("Processing ranges... (this may take a moment)")

    let result = GiftShop.processRanges(ranges)

    print("\nFinal Answer: \(result)")
    print("\nThe sum of all invalid product IDs is: \(result)")
} else {
    print("Could not read input.txt")
}
