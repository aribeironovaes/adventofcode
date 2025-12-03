import Foundation

// MARK: - Advent of Code 2025 - Day 1: Secret Entrance
//
// Problem Overview:
// ===============
// Part 1: Count times the dial LANDS on 0 (rotation ends on 0)
// Part 2: Count every time the dial PASSES THROUGH or lands on 0 (method 0x434C49434B)
//
// The dial is circular with positions 0-99, starting at position 50.
// Rotation instructions: L (left/lower) or R (right/higher) with number of clicks

print("=== Advent of Code 2025 - Day 1: Secret Entrance ===\n")

// Sample input
let sampleInput = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""

let sampleRotations = InputReader.parseRotations(from: sampleInput)
let actualRotations = InputReader.readRotations(from: "input.txt")

// MARK: - Part 1: Count times landing on 0

print("--- Part 1: Count Times Landing on 0 ---\n")

// Test with sample
print("Testing with sample input...")
let sampleDialPart1 = SafeDial(startingPosition: 50)
let sampleResultPart1 = sampleDialPart1.processRotations(sampleRotations)
print("Sample result: \(sampleResultPart1)")
print("Expected: 3")
print(sampleResultPart1 == 3 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")

// Solve Part 1
print("Solving Part 1...")
if !actualRotations.isEmpty {
    let dialPart1 = SafeDial(startingPosition: 50)
    let resultPart1 = dialPart1.processRotations(actualRotations)
    print("Part 1 Answer: \(resultPart1)")
    print()
} else {
    print("No rotations found in input.txt\n")
}

// MARK: - Part 2: Count every click through 0

print("--- Part 2: Count Every Click Through 0 (Method 0x434C49434B) ---\n")

// Test with sample
print("Testing with sample input...")
let sampleDialPart2 = SafeDial(startingPosition: 50)
let sampleResultPart2 = sampleDialPart2.processRotationsPart2(sampleRotations)
print("Sample result: \(sampleResultPart2)")
print("Expected: 6")
print(sampleResultPart2 == 6 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")

// Solve Part 2
print("Solving Part 2...")
if !actualRotations.isEmpty {
    let dialPart2 = SafeDial(startingPosition: 50)
    let resultPart2 = dialPart2.processRotationsPart2(actualRotations)
    print("Part 2 Answer: \(resultPart2)")
    print("\nThe password using method 0x434C49434B is: \(resultPart2)")
} else {
    print("No rotations found in input.txt")
}
