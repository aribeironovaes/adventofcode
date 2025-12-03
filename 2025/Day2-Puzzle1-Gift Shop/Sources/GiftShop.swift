import Foundation

/// Gift Shop validator for finding invalid product IDs
class GiftShop {

    // MARK: - Part 1: Exactly Twice Repetition

    /// Check if a product ID is invalid (repeated digit pattern exactly twice)
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

    // MARK: - Part 2: At Least Twice Repetition

    /// Check if a product ID is invalid (repeated digit pattern at least twice)
    /// An invalid ID is one where a sequence of digits is repeated 2 or more times
    /// Examples: 55 (5 twice), 123123123 (123 three times), 1111111 (1 seven times)
    /// - Parameter id: The product ID to check
    /// - Returns: True if the ID is invalid (repeated pattern), false otherwise
    static func isInvalidIDPart2(_ id: Int) -> Bool {
        let str = String(id)
        let len = str.count

        // Need at least 2 characters to have a repeating pattern
        guard len >= 2 else { return false }

        // Try all possible pattern lengths from 1 to len/2
        // (pattern must repeat at least twice, so max length is len/2)
        for patternLength in 1...(len / 2) {
            // Check if the length is divisible by this pattern length
            guard len % patternLength == 0 else { continue }

            // Extract the pattern (first chunk)
            let pattern = str.prefix(patternLength)

            // Check if the entire string is made of this pattern repeated
            var isRepeated = true
            var index = patternLength

            while index < len {
                let start = str.index(str.startIndex, offsetBy: index)
                let end = str.index(start, offsetBy: patternLength)
                let chunk = str[start..<end]

                if chunk != pattern {
                    isRepeated = false
                    break
                }

                index += patternLength
            }

            // If we found a repeating pattern, it's invalid
            if isRepeated {
                return true
            }
        }

        return false
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

    /// Find all invalid IDs in a given range (Part 2 rules) and return their sum
    /// - Parameter range: The range of IDs to check
    /// - Returns: Sum of all invalid IDs in the range
    static func sumInvalidIDsPart2(in range: ClosedRange<Int>) -> Int {
        var sum = 0
        for id in range {
            if isInvalidIDPart2(id) {
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

    /// Process multiple ranges (Part 2 rules) and return the total sum of all invalid IDs
    /// - Parameter ranges: Array of ID ranges to check
    /// - Returns: Total sum of all invalid IDs across all ranges
    static func processRangesPart2(_ ranges: [ClosedRange<Int>]) -> Int {
        var totalSum = 0
        for range in ranges {
            totalSum += sumInvalidIDsPart2(in: range)
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
