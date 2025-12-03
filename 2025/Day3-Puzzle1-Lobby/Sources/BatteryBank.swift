import Foundation

/// Battery Bank manager for finding maximum joltage
class BatteryBank {

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

    /// Calculate total output joltage from multiple banks
    /// - Parameter banks: Array of battery bank strings
    /// - Returns: Sum of maximum joltage from each bank
    static func totalOutputJoltage(from banks: [String]) -> Int {
        return banks.reduce(0) { sum, bank in
            sum + maximumJoltage(from: bank)
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
