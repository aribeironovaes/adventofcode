import Foundation

// MARK: - Advent of Code 2025 - Day 4: Printing Department
//
// Problem Overview:
// ===============
// We need to count paper rolls that forklifts can access.
// A roll is accessible if it has fewer than 4 rolls in the 8 adjacent positions.

print("=== Advent of Code 2025 - Day 4: Printing Department ===\n")

// Sample input
let sampleInput = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"""

// Read actual input
let actualInput = InputReader.readFile(from: "input.txt")

// MARK: - Part 1: Count Accessible Rolls

print("--- Part 1: Count Accessible Rolls ---\n")

// Test with sample input
print("Testing with sample input...")
let sampleDepartment = PrintingDepartment(gridString: sampleInput)
let sampleResult = sampleDepartment.countAccessibleRolls()

print("Sample grid visualization (accessible rolls marked with 'x'):")
print(sampleDepartment.visualizeAccessibleRolls())

print("Sample result: \(sampleResult)")
print("Expected: 13")
print(sampleResult == 13 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")

// Solve Part 1
print("Solving Part 1...")
if let content = actualInput {
    let department = PrintingDepartment(gridString: content)
    let result = department.countAccessibleRolls()
    print("Part 1 Answer: \(result)")
    print("\nTotal accessible rolls: \(result)")
} else {
    print("Could not read input.txt")
}

// MARK: - Part 2: Iterative Removal

print("\n--- Part 2: Iterative Removal ---\n")

// Test with sample
print("Testing with sample input...")
let sampleDepartmentPart2 = PrintingDepartment(gridString: sampleInput)
let sampleResultPart2 = sampleDepartmentPart2.removeAllAccessibleRolls()
print("Sample result: \(sampleResultPart2)")
print("Expected: 43")
print(sampleResultPart2 == 43 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")

// Solve Part 2
print("Solving Part 2...")
if let content = actualInput {
    let department = PrintingDepartment(gridString: content)
    let result = department.removeAllAccessibleRolls()
    print("Part 2 Answer: \(result)")
    print("\nTotal rolls removed: \(result)")
} else {
    print("Could not read input.txt")
}
