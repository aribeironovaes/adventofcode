import Foundation

// MARK: - Advent of Code 2025 - Day 6: Trash Compactor
//
// Problem Overview:
// ===============
// Solve cephalopod math problems arranged in vertical columns.
// Each column has numbers stacked vertically with an operator at the bottom.
// Calculate each problem and sum all answers for the grand total.

print("=== Advent of Code 2025 - Day 6: Trash Compactor ===\n")

// Read inputs
let sampleInput = InputReader.readFile(from: "sample.txt")
let actualInput = InputReader.readFile(from: "input.txt")

// MARK: - Part 1: Calculate Grand Total

print("--- Part 1: Calculate Grand Total ---\n")

// Test with sample
print("Testing with sample input...")
if let content = sampleInput, let worksheet = MathWorksheet.parse(from: content) {
    let result = worksheet.calculateGrandTotal()
    print("Sample result: \(result)")
    print("Expected: 4277556")
    print(result == 4277556 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not parse sample.txt\n")
}

// Solve Part 1
print("Solving Part 1...")
if let content = actualInput, let worksheet = MathWorksheet.parse(from: content) {
    let result = worksheet.calculateGrandTotal()
    print("Part 1 Answer: \(result)")
    print("\nGrand total: \(result)")
} else {
    print("Could not parse input.txt")
}
