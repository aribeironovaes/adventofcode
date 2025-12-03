import Foundation

// MARK: - Advent of Code 2025 - Day 1 Part 2: Secret Entrance Method 0x434C49434B
//
// Problem Overview:
// ===============
// Part 2 uses "method 0x434C49434B" which counts EVERY click that passes through
// or lands on position 0, not just when a rotation ends on 0.
//
// For example:
// - L68 from position 50 goes to 82, passing through 0 once (count: 1)
// - R48 from position 52 goes to 0 (count: 1)
// - R60 from position 95 goes to 55, passing through 0 once (count: 1)
//
// The key insight: We need to count how many times we cross 0 during each rotation,
// including complete rotations (every 100 clicks passes through 0 once).

print("=== Advent of Code 2025 - Day 1 Part 2: Method 0x434C49434B ===\n")

// Test with sample input
print("Testing with sample input...")
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
let sampleDial = SafeDial(startingPosition: 50)
let sampleResult = sampleDial.processRotations(sampleRotations)
print("Sample result: \(sampleResult)")
print("Expected: 6")
print(sampleResult == 6 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")

// Solve the actual puzzle
print("Solving the actual puzzle...")
let rotations = InputReader.readRotations(from: "input.txt")

if rotations.isEmpty {
    print("No rotations found. Make sure input.txt exists in the Inputs folder.")
} else {
    let dial = SafeDial(startingPosition: 50)
    let result = dial.processRotations(rotations)

    print("\nFinal Answer: \(result)")
    print("\nThe password using method 0x434C49434B is: \(result)")
}
