import Foundation

/// PrintingDepartment handles the grid of paper rolls and checks accessibility
class PrintingDepartment {
    private var grid: [[Character]]  // Mutable for Part 2
    private let rows: Int
    private let cols: Int

    /// Initialize with a grid string
    init(gridString: String) {
        let lines = gridString.split(separator: "\n").map { String($0) }
        self.grid = lines.map { Array($0) }
        self.rows = grid.count
        self.cols = grid.first?.count ?? 0
    }

    /// Check if a position at (row, col) is accessible
    /// A roll is accessible if it has fewer than 4 adjacent rolls
    func isAccessible(row: Int, col: Int) -> Bool {
        // Must be a roll
        guard grid[row][col] == "@" else { return false }

        // Count adjacent rolls in all 8 directions
        let adjacentCount = countAdjacentRolls(row: row, col: col)

        return adjacentCount < 4
    }

    /// Count how many rolls are adjacent to position (row, col)
    /// Checks all 8 directions: N, S, E, W, NE, NW, SE, SW
    private func countAdjacentRolls(row: Int, col: Int) -> Int {
        let directions = [
            (-1, 0),  // N
            (1, 0),   // S
            (0, -1),  // W
            (0, 1),   // E
            (-1, -1), // NW
            (-1, 1),  // NE
            (1, -1),  // SW
            (1, 1)    // SE
        ]

        var count = 0
        for (dr, dc) in directions {
            let newRow = row + dr
            let newCol = col + dc

            // Check bounds - use actual row length, not fixed cols
            guard newRow >= 0 && newRow < rows && newCol >= 0 && newCol < grid[newRow].count else {
                continue
            }

            // Check if it's a roll
            if grid[newRow][newCol] == "@" {
                count += 1
            }
        }

        return count
    }

    /// Count total accessible positions in the grid
    /// An accessible position is an empty space with fewer than 4 adjacent rolls
    func countAccessibleRolls() -> Int {
        var count = 0

        for row in 0..<rows {
            for col in 0..<grid[row].count {
                if isAccessible(row: row, col: col) {
                    count += 1
                }
            }
        }

        return count
    }

    // MARK: - Part 2: Iterative Removal

    /// Remove all accessible rolls and return how many were removed
    /// Modifies the grid by replacing accessible @ with .
    private func removeAccessibleRolls() -> Int {
        var removed: [(Int, Int)] = []

        // Find all accessible rolls
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                if isAccessible(row: row, col: col) {
                    removed.append((row, col))
                }
            }
        }

        // Remove them (replace with .)
        for (row, col) in removed {
            grid[row][col] = "."
        }

        return removed.count
    }

    /// Keep removing accessible rolls until none remain
    /// Returns total number of rolls removed
    func removeAllAccessibleRolls() -> Int {
        var totalRemoved = 0

        while true {
            let removed = removeAccessibleRolls()
            if removed == 0 {
                break
            }
            totalRemoved += removed
        }

        return totalRemoved
    }

    /// Get a visual representation showing accessible rolls
    func visualizeAccessibleRolls() -> String {
        var result = ""

        for row in 0..<rows {
            for col in 0..<grid[row].count {
                if grid[row][col] == "@" && isAccessible(row: row, col: col) {
                    result += "x"
                } else {
                    result += String(grid[row][col])
                }
            }
            result += "\n"
        }

        return result
    }
}
