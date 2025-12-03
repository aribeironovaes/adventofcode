import Foundation

// MARK: - Advent of Code 2025 - Day 2: Gift Shop
//
// Problem Overview:
// ===============
// Part 1: Find invalid product IDs where a sequence of digits is repeated exactly twice.
// Part 2: Find invalid product IDs where a sequence of digits is repeated at least twice.
//
// Examples of invalid IDs:
// - 55 (5 repeated twice) - Invalid in both parts
// - 6464 (64 repeated twice) - Invalid in both parts
// - 123123123 (123 repeated three times) - Invalid in Part 2 only
// - 1111111 (1 repeated seven times) - Invalid in Part 2 only
//
// For each range, find all invalid IDs and sum them up.

print("=== Advent of Code 2025 - Day 2: Gift Shop ===\n")

// Read input once
let sampleInput = InputReader.readFile(from: "sample.txt")
let actualInput = InputReader.readFile(from: "input.txt")

// MARK: - Part 1

print("--- Part 1: Exactly Twice Repetition ---\n")

// Test with sample input
print("Testing with sample input...")
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
print("Solving Part 1...")
if let content = actualInput {
    let ranges = GiftShop.parseRanges(from: content)
    print("Found \(ranges.count) ranges to process")
    print("Processing ranges...")

    let result = GiftShop.processRanges(ranges)

    print("Part 1 Answer: \(result)")
    print()
} else {
    print("Could not read input.txt\n")
}

// MARK: - Part 2

print("--- Part 2: At Least Twice Repetition ---\n")

// Test with sample input
print("Testing with sample input...")
if let sampleContent = sampleInput {
    let sampleRanges = GiftShop.parseRanges(from: sampleContent)
    print("Found \(sampleRanges.count) ranges to process")

    let sampleResult = GiftShop.processRangesPart2(sampleRanges)
    print("Sample result: \(sampleResult)")
    print("Expected: 4174379265")
    print(sampleResult == 4174379265 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not read sample.txt\n")
}

// Solve the actual puzzle
print("Solving Part 2...")
if let content = actualInput {
    let ranges = GiftShop.parseRanges(from: content)
    print("Found \(ranges.count) ranges to process")
    print("Processing ranges... (this may take a moment)")

    let result = GiftShop.processRangesPart2(ranges)

    print("Part 2 Answer: \(result)")
    print("\nThe sum of all invalid product IDs (Part 2 rules) is: \(result)")
} else {
    print("Could not read input.txt")
}
