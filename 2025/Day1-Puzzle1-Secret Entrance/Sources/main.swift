import Foundation

// MARK: - Advent of Code 2025 - Day 1: Secret Entrance
//
// Problem Overview:
// ===============
// We have a circular safe dial with numbers 0-99. The dial starts at position 50.
// We receive a sequence of rotation instructions (e.g., "L68" or "R48"):
//   - L means rotate LEFT (toward lower numbers)
//   - R means rotate RIGHT (toward higher numbers)
//   - The number indicates how many clicks to rotate
//
// The dial is circular, so:
//   - Rotating left from 0 goes to 99
//   - Rotating right from 99 goes to 0
//
// Our goal: Count how many times the dial lands on 0 after any rotation.

print("=== Advent of Code 2025 - Day 1: Secret Entrance ===\n")

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
print("Expected: 3")
print(sampleResult == 3 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")

// Solve the actual puzzle
print("Solving the actual puzzle...")
let rotations = InputReader.readRotations(from: "input.txt")

if rotations.isEmpty {
    print("No rotations found. Make sure input.txt exists in the Inputs folder.")
} else {
    let dial = SafeDial(startingPosition: 50)
    let result = dial.processRotations(rotations)

    print("\nFinal Answer: \(result)")
    print("\nThe password to open the door is: \(result)")
}
