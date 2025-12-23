import Foundation

let inputPath = "Inputs/input.txt"
guard let content = try? String(contentsOfFile: inputPath, encoding: .utf8) else {
    print("Failed")
    exit(1)
}

struct Point: Hashable {
    let x: Int, y: Int
}

let lines = content.split(separator: "\n").map { String($0) }
var redTiles: [Point] = []

for line in lines {
    let coords = line.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    guard coords.count == 2 else { continue }
    redTiles.append(Point(x: coords[0], y: coords[1]))
}

print("Red tiles: \(redTiles.count)")

// Build boundary
var boundary = Set<Point>()
for i in 0..<redTiles.count {
    let start = redTiles[i]
    let end = redTiles[(i + 1) % redTiles.count]

    if start.x == end.x {
        for y in min(start.y, end.y)...max(start.y, end.y) {
            boundary.insert(Point(x: start.x, y: y))
        }
    } else if start.y == end.y {
        for x in min(start.x, end.x)...max(start.x, end.x) {
            boundary.insert(Point(x: x, y: start.y))
        }
    }
}

print("Boundary tiles: \(boundary.count)")

let redSet = Set(redTiles)
var cache: [Point: Bool] = [:]

func isInsidePolygon(_ point: Point) -> Bool {
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

func isValidTile(_ point: Point) -> Bool {
    if redSet.contains(point) || boundary.contains(point) {
        return true
    }
    if let cached = cache[point] {
        return cached
    }
    let result = isInsidePolygon(point)
    cache[point] = result
    return result
}

// Strategy: Check rectangles in batches by area range
// Start from areas we know work (around 3M) and expand
let areaRanges = [
    (3_000_000, 3_500_000),
    (3_500_000, 4_000_000),
    (2_500_000, 3_000_000),
    (4_000_000, 5_000_000),
    (2_000_000, 2_500_000),
    (5_000_000, 7_000_000),
    (1_500_000, 2_000_000),
    (7_000_000, 10_000_000)
]

var globalMax = 0

for (minArea, maxArea) in areaRanges {
    print("\nChecking area range: \(minArea) to \(maxArea)")
    var candidates: [(Point, Point, Int)] = []

    for i in 0..<redTiles.count {
        for j in (i+1)..<redTiles.count {
            let t1 = redTiles[i]
            let t2 = redTiles[j]
            let area = (abs(t1.x - t2.x) + 1) * (abs(t1.y - t2.y) + 1)

            if area >= minArea && area <= maxArea {
                candidates.append((t1, t2, area))
            }
        }
    }

    candidates.sort { $0.2 > $1.2 }
    print("Found \(candidates.count) candidates in this range")

    for (idx, (c1, c2, area)) in candidates.enumerated() {
        if idx % 100 == 0 && idx > 0 {
            print("  Checked \(idx)/\(candidates.count)")
        }

        if area <= globalMax {
            continue
        }

        let minX = min(c1.x, c2.x)
        let maxX = max(c1.x, c2.x)
        let minY = min(c1.y, c2.y)
        let maxY = max(c1.y, c2.y)

        var valid = true
        outer: for y in minY...maxY {
            for x in minX...maxX {
                if !isValidTile(Point(x: x, y: y)) {
                    valid = false
                    break outer
                }
            }
        }

        if valid {
            print("✓ Found valid: \(area)")
            globalMax = area
        }
    }

    print("Best so far: \(globalMax)")
}

print("\n=== FINAL ANSWER: \(globalMax) ===")
