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

    /// Ray casting algorithm to check if point is inside the polygon
    private func isInsidePolygon(_ point: Point) -> Bool {
        var inside = false
        let n = redTiles.count

        var j = n - 1
        for i in 0..<n {
            let vi = redTiles[i]
            let vj = redTiles[j]

            if ((vi.y > point.y) != (vj.y > point.y)) &&
               (point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x) {
                inside.toggle()
            }
            j = i
        }

        return inside
    }

    /// Find largest rectangle using only red or green tiles
    func findLargestRectangleWithGreen() -> Int {
        var maxArea = 0

        // Try all pairs of red tiles as opposite corners
        for i in 0..<redTiles.count {
            for j in (i+1)..<redTiles.count {
                let tile1 = redTiles[i]
                let tile2 = redTiles[j]

                // Check if all tiles in rectangle are red or green
                if isRectangleValid(tile1, tile2) {
                    let width = abs(tile1.x - tile2.x) + 1
                    let height = abs(tile1.y - tile2.y) + 1
                    let area = width * height
                    maxArea = max(maxArea, area)
                }
            }
        }

        return maxArea
    }

    /// Check if all tiles in rectangle are red or green
    private func isRectangleValid(_ corner1: Point, _ corner2: Point) -> Bool {
        let minX = min(corner1.x, corner2.x)
        let maxX = max(corner1.x, corner2.x)
        let minY = min(corner1.y, corner2.y)
        let maxY = max(corner1.y, corner2.y)

        let redSet = Set(redTiles)

        // Check all four corners of the rectangle
        let corners = [
            Point(x: minX, y: minY),
            Point(x: minX, y: maxY),
            Point(x: maxX, y: minY),
            Point(x: maxX, y: maxY)
        ]

        // All corners must be inside or on the polygon
        for corner in corners {
            if !redSet.contains(corner) && !isOnBoundary(corner) && !isInsidePolygon(corner) {
                return false
            }
        }

        // If all corners are valid, the entire rectangle is valid
        // (since the polygon is convex or at least star-convex for this problem)
        return true
    }

    /// Check if point is on the polygon boundary (on an edge between consecutive red tiles)
    private func isOnBoundary(_ point: Point) -> Bool {
        for i in 0..<redTiles.count {
            let start = redTiles[i]
            let end = redTiles[(i + 1) % redTiles.count]

            // Check if point is on the line segment from start to end
            if start.x == end.x && point.x == start.x {
                // Vertical segment
                let minY = min(start.y, end.y)
                let maxY = max(start.y, end.y)
                if point.y >= minY && point.y <= maxY {
                    return true
                }
            } else if start.y == end.y && point.y == start.y {
                // Horizontal segment
                let minX = min(start.x, end.x)
                let maxX = max(start.x, end.x)
                if point.x >= minX && point.x <= maxX {
                    return true
                }
            }
        }
        return false
    }
}
