import Foundation

/// Battery Bank manager for finding maximum joltage
class BatteryBank {

    // MARK: - Part 1: Select 2 Batteries

    /// Find the maximum joltage possible from a bank of batteries
    /// We need to turn on exactly two batteries, and the joltage is formed
    /// by concatenating their digits in order.
    ///
    /// For example, "12345" with batteries at positions 1 and 3 produces "24"
    ///
    /// - Parameter bank: String of digits representing battery joltages
    /// - Returns: The maximum joltage possible
    static func maximumJoltage(from bank: String) -> Int {
        let batteries = Array(bank)
        let count = batteries.count

        // Need at least 2 batteries
        guard count >= 2 else { return 0 }

        var maxJoltage = 0

        // Try all pairs of batteries (i, j) where i < j
        for i in 0..<(count - 1) {
            for j in (i + 1)..<count {
                // Form the 2-digit number from batteries at positions i and j
                let digit1 = String(batteries[i])
                let digit2 = String(batteries[j])
                let joltageStr = digit1 + digit2

                if let joltage = Int(joltageStr) {
                    maxJoltage = max(maxJoltage, joltage)
                }
            }
        }

        return maxJoltage
    }

    // MARK: - Part 2: Select 12 Batteries

    /// Find the maximum joltage by selecting exactly 12 batteries
    /// Uses a greedy algorithm to select digits that maximize the result
    /// while maintaining their relative order.
    ///
    /// Algorithm: For each position in the 12-digit result, look ahead at
    /// available source digits and pick the maximum one that still leaves
    /// enough digits for the remaining positions.
    ///
    /// - Parameter bank: String of digits representing battery joltages
    /// - Returns: The maximum 12-digit joltage possible
    static func maximumJoltageWith12(from bank: String) -> Int {
        let digits = Array(bank)
        let n = digits.count
        let k = 12  // number of batteries to select

        // Need at least 12 batteries
        guard n >= k else { return 0 }

        var result = ""
        var sourcePos = 0

        // Build the 12-digit result one digit at a time
        for resultPos in 0..<k {
            let remaining = k - resultPos  // how many more digits we need
            let latestStart = n - remaining  // latest position we can pick from

            // Find the maximum digit in the valid range
            var maxDigit = Character("0")
            var maxPos = sourcePos

            for pos in sourcePos...latestStart {
                if digits[pos] > maxDigit {
                    maxDigit = digits[pos]
                    maxPos = pos
                }
            }

            result.append(maxDigit)
            sourcePos = maxPos + 1
        }

        return Int(result) ?? 0
    }

    /// Calculate total output joltage from multiple banks
    /// - Parameter banks: Array of battery bank strings
    /// - Returns: Sum of maximum joltage from each bank
    static func totalOutputJoltage(from banks: [String]) -> Int {
        return banks.reduce(0) { sum, bank in
            sum + maximumJoltage(from: bank)
        }
    }

    /// Calculate total output joltage from multiple banks (Part 2: 12 batteries)
    /// - Parameter banks: Array of battery bank strings
    /// - Returns: Sum of maximum 12-digit joltage from each bank
    static func totalOutputJoltagePart2(from banks: [String]) -> Int {
        return banks.reduce(0) { sum, bank in
            sum + maximumJoltageWith12(from: bank)
        }
    }

    /// Parse banks from input string
    /// - Parameter input: Multi-line string with one bank per line
    /// - Returns: Array of bank strings
    static func parseBanks(from input: String) -> [String] {
        return input
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
