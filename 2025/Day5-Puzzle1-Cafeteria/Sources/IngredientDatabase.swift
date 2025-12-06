import Foundation

/// Represents a range of fresh ingredient IDs
struct IngredientRange {
    let start: Int
    let end: Int

    /// Check if an ID falls within this range
    func contains(_ id: Int) -> Bool {
        return id >= start && id <= end
    }

    /// Parse a range from string like "3-5"
    init?(from string: String) {
        let parts = string.split(separator: "-")
        guard parts.count == 2,
              let start = Int(parts[0]),
              let end = Int(parts[1]) else {
            return nil
        }
        self.start = start
        self.end = end
    }
}

/// Manages the ingredient database
class IngredientDatabase {
    private let ranges: [IngredientRange]
    private let ingredientIDs: [Int]

    init(ranges: [IngredientRange], ingredientIDs: [Int]) {
        self.ranges = ranges
        self.ingredientIDs = ingredientIDs
    }

    /// Check if an ingredient ID is fresh (falls into any range)
    func isFresh(_ id: Int) -> Bool {
        return ranges.contains { $0.contains(id) }
    }

    /// Count how many of the available ingredient IDs are fresh
    func countFreshIngredients() -> Int {
        return ingredientIDs.filter { isFresh($0) }.count
    }

    /// Parse database from input string
    static func parse(from input: String) -> IngredientDatabase? {
        let sections = input.components(separatedBy: "\n\n")
        guard sections.count == 2 else { return nil }

        // Parse ranges
        let rangeLines = sections[0].split(separator: "\n")
        let ranges = rangeLines.compactMap { IngredientRange(from: String($0)) }

        // Parse ingredient IDs
        let idLines = sections[1].split(separator: "\n")
        let ids = idLines.compactMap { Int($0) }

        return IngredientDatabase(ranges: ranges, ingredientIDs: ids)
    }
}
