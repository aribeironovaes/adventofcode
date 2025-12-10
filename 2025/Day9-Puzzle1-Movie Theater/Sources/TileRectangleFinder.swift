import Foundation

/// Represents a point (tile position)
struct Point: Hashable {
    let x: Int
    let y: Int
}

/// Finds the largest rectangle using red tiles as opposite corners
class TileRectangleFinder {
    private let redTiles: [Point]

    init?(from input: String) {
        let lines = input.split(separator: "\n").map { String($0) }
        guard !lines.isEmpty else { return nil }

        var tiles: [Point] = []
        for line in lines {
            let coords = line.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            guard coords.count == 2 else { continue }
            tiles.append(Point(x: coords[0], y: coords[1]))
        }

        guard !tiles.isEmpty else { return nil }
        self.redTiles = tiles
    }

    /// Find the largest rectangle area using any two red tiles as opposite corners
    func findLargestRectangleArea() -> Int {
        var maxArea = 0

        // Try all pairs of red tiles as opposite corners
        for i in 0..<redTiles.count {
            for j in (i+1)..<redTiles.count {
                let tile1 = redTiles[i]
                let tile2 = redTiles[j]

                // Calculate rectangle area (inclusive of both corners)
                let width = abs(tile1.x - tile2.x) + 1
                let height = abs(tile1.y - tile2.y) + 1
                let area = width * height

                maxArea = max(maxArea, area)
            }
        }

        return maxArea
    }
}
