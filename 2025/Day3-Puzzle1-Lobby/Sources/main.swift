import Foundation

// MARK: - Advent of Code 2025 - Day 3: Lobby
//
// Problem Overview:
// ===============
// We have battery banks where each battery has a joltage rating (1-9).
// For each bank, we turn on exactly TWO batteries.
// The joltage produced is the 2-digit number formed by those batteries in order.
//
// Goal: Find the maximum joltage each bank can produce and sum them all.
//
// Example:
// - Bank "987654321111111": Turn on batteries at positions 0 and 1 (9 and 8) → 98 jolts
// - Bank "811111111111119": Turn on batteries at positions 0 and 14 (8 and 9) → 89 jolts
// - Bank "234234234234278": Turn on batteries at positions 13 and 14 (7 and 8) → 78 jolts
// - Bank "818181911112111": Turn on batteries at positions 6 and 11 (9 and 2) → 92 jolts
// Total: 98 + 89 + 78 + 92 = 357

print("=== Advent of Code 2025 - Day 3: Lobby ===\n")

// Read input once
let sampleInput = InputReader.readFile(from: "sample.txt")
let actualInput = InputReader.readFile(from: "input.txt")

// Test with sample input
print("Testing with sample input...")
if let sampleContent = sampleInput {
    let sampleBanks = BatteryBank.parseBanks(from: sampleContent)
    print("Found \(sampleBanks.count) battery banks")

    // Show details for each sample bank
    for (index, bank) in sampleBanks.enumerated() {
        let maxJoltage = BatteryBank.maximumJoltage(from: bank)
        print("  Bank \(index + 1): \(bank) → max joltage: \(maxJoltage)")
    }

    let sampleResult = BatteryBank.totalOutputJoltage(from: sampleBanks)
    print("\nSample result: \(sampleResult)")
    print("Expected: 357")
    print(sampleResult == 357 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not read sample.txt\n")
}

// Solve the actual puzzle
print("Solving the actual puzzle...")
if let content = actualInput {
    let banks = BatteryBank.parseBanks(from: content)
    print("Found \(banks.count) battery banks")
    print("Processing banks...")

    let result = BatteryBank.totalOutputJoltage(from: banks)

    print("\nFinal Answer: \(result)")
    print("\nThe total output joltage is: \(result)")
} else {
    print("Could not read input.txt")
}
