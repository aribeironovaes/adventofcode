import Foundation

// Sample input
let sample = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"""

struct Point: Hashable {
    let x: Int, y: Int
}

let lines = sample.split(separator: "\n").map { String($0) }
var redTiles: [Point] = []

for line in lines {
    let coords = line.split(separator: ",").compactMap { Int($0) }
    redTiles.append(Point(x: coords[0], y: coords[1]))
}

print("=== VERIFYING SAMPLE ===\n")
print("Red tiles (in order):")
for (i, tile) in redTiles.enumerated() {
    print("\(i): (\(tile.x), \(tile.y))")
}

// The expected answer for Part 2 is 24
// Rectangle from (9,5) to (2,3)
// Let's verify: width = |9-2|+1 = 8, height = |5-3|+1 = 3, area = 24 ✓

print("\nExpected answer rectangle: (9,5) to (2,3)")
let w = abs(9-2) + 1
let h = abs(5-3) + 1
print("Width: \(w), Height: \(h), Area: \(w*h)")

// Now let's verify MY understanding of green tiles
print("\n=== Building Boundary (green tiles connecting red tiles) ===")

var boundary = Set<Point>()
for i in 0..<redTiles.count {
    let start = redTiles[i]
    let end = redTiles[(i + 1) % redTiles.count]

    print("Edge \(i): (\(start.x),\(start.y)) -> (\(end.x),\(end.y))")

    if start.x == end.x {
        // Vertical
        let minY = min(start.y, end.y)
        let maxY = max(start.y, end.y)
        for y in minY...maxY {
            boundary.insert(Point(x: start.x, y: y))
        }
        print("  Added \(maxY - minY + 1) boundary tiles (vertical)")
    } else if start.y == end.y {
        // Horizontal
        let minX = min(start.x, end.x)
        let maxX = max(start.x, end.x)
        for x in minX...maxX {
            boundary.insert(Point(x: x, y: start.y))
        }
        print("  Added \(maxX - minX + 1) boundary tiles (horizontal)")
    } else {
        print("  ERROR: Not axis-aligned!")
    }
}

print("\nTotal boundary tiles: \(boundary.count)")

// Ray casting for interior
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

// Find all green tiles (boundary + interior)
let redSet = Set(redTiles)
var greenTiles = boundary

let minX = redTiles.map { $0.x }.min()!
let maxX = redTiles.map { $0.x }.max()!
let minY = redTiles.map { $0.y }.min()!
let maxY = redTiles.map { $0.y }.max()!

for y in minY...maxY {
    for x in minX...maxX {
        let p = Point(x: x, y: y)
        if !boundary.contains(p) && !redSet.contains(p) && isInsidePolygon(p) {
            greenTiles.insert(p)
        }
    }
}

print("Total green tiles (boundary + interior): \(greenTiles.count)")

// Now validate the expected rectangle (9,5) to (2,3)
print("\n=== Validating Expected Rectangle ===")
let c1 = Point(x: 9, y: 5)
let c2 = Point(x: 2, y: 3)

let rectMinX = min(c1.x, c2.x)
let rectMaxX = max(c1.x, c2.x)
let rectMinY = min(c1.y, c2.y)
let rectMaxY = max(c1.y, c2.y)

print("Rectangle bounds: x[\(rectMinX)..\(rectMaxX)] y[\(rectMinY)..\(rectMaxY)]")

var invalidTiles: [Point] = []
for y in rectMinY...rectMaxY {
    for x in rectMinX...rectMaxX {
        let p = Point(x: x, y: y)
        if !redSet.contains(p) && !greenTiles.contains(p) {
            invalidTiles.append(p)
        }
    }
}

if invalidTiles.isEmpty {
    print("✓ All tiles in rectangle are valid (red or green)")
} else {
    print("✗ Found \(invalidTiles.count) INVALID tiles:")
    for tile in invalidTiles.prefix(10) {
        print("  (\(tile.x), \(tile.y))")
    }
}

// Visualize
print("\n=== Visual Grid (0-12 x, 0-8 y) ===")
for y in 0...8 {
    var row = ""
    for x in 0...12 {
        let p = Point(x: x, y: y)
        if redSet.contains(p) {
            row += "#"
        } else if greenTiles.contains(p) {
            row += "X"
        } else if x >= rectMinX && x <= rectMaxX && y >= rectMinY && y <= rectMaxY {
            row += "O"  // In our rectangle
        } else {
            row += "."
        }
    }
    print(row)
}

print("\n=== Key: # = red, X = green, O = in rectangle but NOT red/green, . = other ===")
