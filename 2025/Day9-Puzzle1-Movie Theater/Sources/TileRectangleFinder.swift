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

    /// Find largest rectangle using only red or green tiles
    /// Uses edge-crossing algorithm from working Python solution
    func findLargestRectangleWithGreen() -> Int {
        var maxArea = 0
        var maxI = 0, maxJ = 0

        for i in 0..<redTiles.count {
            for j in 0..<i {
                let area = calculateArea(redTiles[i], redTiles[j])

                if area > maxArea && isRectangleValid(i, j) {
                    maxArea = area
                    maxI = i
                    maxJ = j
                }
            }
        }

        print("✓ Found valid rectangle")
        print("  Area: \(maxArea)")
        print("  Corners: (\(redTiles[maxI].x),\(redTiles[maxI].y)) to (\(redTiles[maxJ].x),\(redTiles[maxJ].y))")

        return maxArea
    }

    /// Check if rectangle is valid using edge-crossing algorithm
    /// This checks if polygon edges cross rectangle boundaries
    private func isRectangleValid(_ i: Int, _ j: Int) -> Bool {
        let x1 = min(redTiles[i].x, redTiles[j].x)
        let x2 = max(redTiles[i].x, redTiles[j].x)
        let y1 = min(redTiles[i].y, redTiles[j].y)
        let y2 = max(redTiles[i].y, redTiles[j].y)

        for k in 0..<redTiles.count {
            let x = redTiles[k].x
            let y = redTiles[k].y

            // Get previous vertex (wraps around)
            let kPrev = (k - 1 + redTiles.count) % redTiles.count
            let xp = redTiles[kPrev].x
            let yp = redTiles[kPrev].y

            // Check 1: No vertex strictly inside rectangle
            if x1 < x && x < x2 && y1 < y && y < y2 {
                return false
            }

            // Check 2: Edge crosses left/right boundary
            if x1 < x && x < x2 && y <= y1 && y1 < yp {
                return false
            }
            if x1 < x && x < x2 && yp <= y1 && y1 < y {
                return false
            }

            // Check 3: Edge crosses top/bottom boundary
            if y1 < y && y < y2 && x <= x1 && x1 < xp {
                return false
            }
            if y1 < y && y < y2 && xp <= x1 && x1 < x {
                return false
            }
        }

        return true
    }

    private func calculateArea(_ p1: Point, _ p2: Point) -> Int {
        return (abs(p1.x - p2.x) + 1) * (abs(p1.y - p2.y) + 1)
    }
}
