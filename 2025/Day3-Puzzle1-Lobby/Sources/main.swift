import Foundation

// MARK: - Advent of Code 2025 - Day 3: Lobby
//
// Problem Overview:
// ===============
// Part 1: Turn on exactly 2 batteries per bank to form a 2-digit number
// Part 2: Turn on exactly 12 batteries per bank to form a 12-digit number
//
// Goal: Find the maximum joltage each bank can produce and sum them all.

print("=== Advent of Code 2025 - Day 3: Lobby ===\n")

// Read input once
let sampleInput = InputReader.readFile(from: "sample.txt")
let actualInput = InputReader.readFile(from: "input.txt")

// MARK: - Part 1: Select 2 Batteries

print("--- Part 1: Select 2 Batteries ---\n")

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

// Solve Part 1
print("Solving Part 1...")
if let content = actualInput {
    let banks = BatteryBank.parseBanks(from: content)
    print("Found \(banks.count) battery banks")

    let result = BatteryBank.totalOutputJoltage(from: banks)
    print("Part 1 Answer: \(result)")
    print()
} else {
    print("Could not read input.txt\n")
}

// MARK: - Part 2: Select 12 Batteries

print("--- Part 2: Select 12 Batteries ---\n")

// Test with sample input
print("Testing with sample input...")
if let sampleContent = sampleInput {
    let sampleBanks = BatteryBank.parseBanks(from: sampleContent)
    print("Found \(sampleBanks.count) battery banks")

    // Show details for each sample bank
    for (index, bank) in sampleBanks.enumerated() {
        let maxJoltage = BatteryBank.maximumJoltageWith12(from: bank)
        print("  Bank \(index + 1): \(bank) → max joltage: \(maxJoltage)")
    }

    let sampleResult = BatteryBank.totalOutputJoltagePart2(from: sampleBanks)
    print("\nSample result: \(sampleResult)")
    print("Expected: 3121910778619")
    print(sampleResult == 3121910778619 ? "✓ Sample test PASSED\n" : "✗ Sample test FAILED\n")
} else {
    print("Could not read sample.txt\n")
}

// Solve Part 2
print("Solving Part 2...")
if let content = actualInput {
    let banks = BatteryBank.parseBanks(from: content)
    print("Found \(banks.count) battery banks")
    print("Processing banks...")

    let result = BatteryBank.totalOutputJoltagePart2(from: banks)
    print("Part 2 Answer: \(result)")
    print("\nThe total output joltage with 12 batteries is: \(result)")
} else {
    print("Could not read input.txt")
}
