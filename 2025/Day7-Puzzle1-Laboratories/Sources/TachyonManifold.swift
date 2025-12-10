import Foundation

/// Represents a tachyon beam position and direction
struct Beam: Hashable {
    let row: Int
    let col: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }
}

/// Simulates tachyon beam splitting in a manifold
class TachyonManifold {
    private let grid: [[Character]]
    private let rows: Int
    private let cols: Int
    private let startCol: Int

    init?(from input: String) {
        let lines = input.split(separator: "\n").map { String($0) }
        guard !lines.isEmpty else { return nil }

        self.grid = lines.map { Array($0) }
        self.rows = grid.count
        self.cols = grid[0].count

        // Find the starting position 'S'
        var foundStart: Int?
        for col in 0..<cols {
            if grid[0][col] == "S" {
                foundStart = col
                break
            }
        }

        guard let start = foundStart else { return nil }
        self.startCol = start
    }

    /// Simulate the beam and count the number of splits
    func countSplits() -> Int {
        var splitCount = 0
        var activeBeams: [Beam] = [Beam(row: 0, col: startCol)]
        var processedSplitters = Set<Beam>()

        while !activeBeams.isEmpty {
            var nextBeams: [Beam] = []

            for beam in activeBeams {
                // Move beam down one row
                let nextRow = beam.row + 1

                // Check if beam exits the manifold
                if nextRow >= rows {
                    continue
                }

                let nextBeam = Beam(row: nextRow, col: beam.col)

                // Check what's at the next position
                let char = grid[nextRow][beam.col]

                if char == "^" {
                    // Hit a splitter - only count if we haven't processed this splitter yet
                    if !processedSplitters.contains(nextBeam) {
                        processedSplitters.insert(nextBeam)
                        splitCount += 1

                        // Create two new beams: one to the left, one to the right
                        if beam.col > 0 {
                            nextBeams.append(Beam(row: nextRow, col: beam.col - 1))
                        }
                        if beam.col < cols - 1 {
                            nextBeams.append(Beam(row: nextRow, col: beam.col + 1))
                        }
                    }
                } else {
                    // Empty space - beam continues downward
                    nextBeams.append(nextBeam)
                }
            }

            activeBeams = nextBeams
        }

        return splitCount
    }
}
