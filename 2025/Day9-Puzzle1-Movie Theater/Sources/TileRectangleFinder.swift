import Foundation

/// Represents a point (tile position)
struct Point: Hashable {
    let x: Int
    let y: Int
}

/// Finds the largest rectangle using red tiles as opposite corners
class TileRectangleFinder {
    private let redTiles: [Point]
    private lazy var boundaryTiles: Set<Point> = {
        computeBoundaryTiles()
    }()
    private lazy var redSet: Set<Point> = Set(redTiles)

    // Cache for polygon tests to avoid redundant ray-casting
    private var polygonTestCache: [Point: Bool] = [:]

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

    /// Pre-compute only boundary tiles (much faster than all interior tiles)
    private func computeBoundaryTiles() -> Set<Point> {
        var boundary = Set<Point>()

        for i in 0..<redTiles.count {
            let start = redTiles[i]
            let end = redTiles[(i + 1) % redTiles.count]

            if start.x == end.x {
                // Vertical edge
                let minY = min(start.y, end.y)
                let maxY = max(start.y, end.y)
                for y in minY...maxY {
                    boundary.insert(Point(x: start.x, y: y))
                }
            } else if start.y == end.y {
                // Horizontal edge
                let minX = min(start.x, end.x)
                let maxX = max(start.x, end.x)
                for x in minX...maxX {
                    boundary.insert(Point(x: x, y: start.y))
                }
            }
        }

        return boundary
    }

    /// Check if point is valid (red, boundary, or interior) with caching
    private func isValidTile(_ point: Point) -> Bool {
        // Quick checks first
        if redSet.contains(point) || boundaryTiles.contains(point) {
            return true
        }

        // Use cached polygon test result if available
        if let cached = polygonTestCache[point] {
            return cached
        }

        // Perform ray-casting and cache result
        let result = isInsidePolygon(point)
        polygonTestCache[point] = result
        return result
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

    /// Check if all tiles in rectangle are valid (with caching for efficiency)
    private func isRectangleValid(_ corner1: Point, _ corner2: Point) -> Bool {
        let minX = min(corner1.x, corner2.x)
        let maxX = max(corner1.x, corner2.x)
        let minY = min(corner1.y, corner2.y)
        let maxY = max(corner1.y, corner2.y)

        let width = maxX - minX + 1
        let height = maxY - minY + 1
        let area = width * height

        // Skip very large rectangles (likely to contain invalid tiles and slow to check)
        // Most valid rectangles should be relatively small
        if area > 100000 {
            return false
        }

        // Check EVERY tile in the rectangle using cached validation
        for y in minY...maxY {
            for x in minX...maxX {
                let point = Point(x: x, y: y)
                if !isValidTile(point) {
                    return false
                }
            }
        }

        return true
    }
}
