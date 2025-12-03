import Foundation

/// Gift Shop validator for finding invalid product IDs
class GiftShop {

    /// Check if a product ID is invalid (repeated digit pattern)
    /// An invalid ID is one where a sequence of digits is repeated exactly twice
    /// Examples: 55 (5 twice), 6464 (64 twice), 123123 (123 twice)
    /// - Parameter id: The product ID to check
    /// - Returns: True if the ID is invalid (repeated pattern), false otherwise
    static func isInvalidID(_ id: Int) -> Bool {
        let str = String(id)
        let len = str.count

        // Must be even length to be a repeated pattern
        guard len % 2 == 0 else { return false }

        // Split in half and compare
        let mid = len / 2
        let firstHalf = str.prefix(mid)
        let secondHalf = str.suffix(mid)

        return firstHalf == secondHalf
    }

    /// Find all invalid IDs in a given range and return their sum
    /// - Parameter range: The range of IDs to check
    /// - Returns: Sum of all invalid IDs in the range
    static func sumInvalidIDs(in range: ClosedRange<Int>) -> Int {
        var sum = 0
        for id in range {
            if isInvalidID(id) {
                sum += id
            }
        }
        return sum
    }

    /// Process multiple ranges and return the total sum of all invalid IDs
    /// - Parameter ranges: Array of ID ranges to check
    /// - Returns: Total sum of all invalid IDs across all ranges
    static func processRanges(_ ranges: [ClosedRange<Int>]) -> Int {
        var totalSum = 0
        for range in ranges {
            totalSum += sumInvalidIDs(in: range)
        }
        return totalSum
    }

    /// Parse a range string like "11-22" into a ClosedRange
    /// - Parameter rangeStr: String in format "start-end"
    /// - Returns: ClosedRange<Int> or nil if parsing fails
    static func parseRange(_ rangeStr: String) -> ClosedRange<Int>? {
        let parts = rangeStr.split(separator: "-")
        guard parts.count == 2,
              let start = Int(parts[0]),
              let end = Int(parts[1]) else {
            return nil
        }
        return start...end
    }

    /// Parse the entire input string into an array of ranges
    /// - Parameter input: Comma-separated range strings
    /// - Returns: Array of ClosedRange<Int>
    static func parseRanges(from input: String) -> [ClosedRange<Int>] {
        return input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .compactMap { parseRange(String($0)) }
    }
}
