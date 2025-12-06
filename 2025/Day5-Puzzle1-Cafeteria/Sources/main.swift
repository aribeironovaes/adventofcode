import Foundation

// MARK: - Advent of Code 2025 - Day 5: Cafeteria
//
// Problem Overview:
// ===============
// Check which ingredient IDs are fresh based on ID ranges.
// An ID is fresh if it falls within any of the given ranges.

print("=== Advent of Code 2025 - Day 5: Cafeteria ===\n")

// Read inputs
let sampleInput = InputReader.readFile(from: "sample.txt")
let actualInput = InputReader.readFile(from: "input.txt")

// MARK: - Part 1: Count Fresh Ingredients

print("--- Part 1: Count Fresh Ingredients ---\n")

// Test with sample
print("Testing with sample input...")
if let content = sampleInput, let database = IngredientDatabase.parse(from: content) {
    let result = database.countFreshIngredients()
    print("Sample result: \(result)")
    print("Expected: 3")
    print(result == 3 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not parse sample.txt\n")
}

// Solve Part 1
print("Solving Part 1...")
if let content = actualInput, let database = IngredientDatabase.parse(from: content) {
    let result = database.countFreshIngredients()
    print("Part 1 Answer: \(result)")
    print("\nTotal fresh ingredients: \(result)")
} else {
    print("Could not parse input.txt")
}

// MARK: - Part 2: Total Fresh IDs Across All Ranges

print("\n--- Part 2: Total Fresh IDs Across All Ranges ---\n")

// Test with sample
print("Testing with sample input...")
if let content = sampleInput, let database = IngredientDatabase.parse(from: content) {
    let result = database.countTotalFreshIDs()
    print("Sample result: \(result)")
    print("Expected: 14")
    print(result == 14 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not parse sample.txt\n")
}

// Solve Part 2
print("Solving Part 2...")
if let content = actualInput, let database = IngredientDatabase.parse(from: content) {
    let result = database.countTotalFreshIDs()
    print("Part 2 Answer: \(result)")
    print("\nTotal unique fresh IDs: \(result)")
} else {
    print("Could not parse input.txt")
}
