import Foundation

// Read actual input
let inputPath = "Inputs/input.txt"
guard let content = try? String(contentsOfFile: inputPath) else {
    print("Failed to read input file")
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

print("Loaded \(redTiles.count) red tiles")

// Build boundary tiles
var boundary = Set<Point>()
for i in 0..<redTiles.count {
    let start = redTiles[i]
    let end = redTiles[(i + 1) % redTiles.count]

    if start.x == end.x {
        let minY = min(start.y, end.y)
        let maxY = max(start.y, end.y)
        for y in minY...maxY {
            boundary.insert(Point(x: start.x, y: y))
        }
    } else if start.y == end.y {
        let minX = min(start.x, end.x)
        let maxX = max(start.x, end.x)
        for x in minX...maxX {
            boundary.insert(Point(x: x, y: start.y))
        }
    }
}

print("Boundary tiles: \(boundary.count)")

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

let redSet = Set(redTiles)

func isValidTile(_ point: Point) -> Bool {
    return redSet.contains(point) || boundary.contains(point) || isInsidePolygon(point)
}

// Find the largest rectangle by area (what the 4-corner check would find)
print("\nFinding largest rectangle by area...")
var maxArea = 0
var maxCorner1: Point?
var maxCorner2: Point?

for i in 0..<redTiles.count {
    for j in (i+1)..<redTiles.count {
        let tile1 = redTiles[i]
        let tile2 = redTiles[j]
        let width = abs(tile1.x - tile2.x) + 1
        let height = abs(tile1.y - tile2.y) + 1
        let area = width * height

        if area > maxArea {
            maxArea = area
            maxCorner1 = tile1
            maxCorner2 = tile2
        }
    }
}

print("Largest rectangle by area: \(maxArea)")
if let c1 = maxCorner1, let c2 = maxCorner2 {
    print("Corners: (\(c1.x),\(c1.y)) to (\(c2.x),\(c2.y))")

    let minX = min(c1.x, c2.x)
    let maxX = max(c1.x, c2.x)
    let minY = min(c1.y, c2.y)
    let maxY = max(c1.y, c2.y)

    print("Rectangle bounds: x[\(minX)..\(maxX)] y[\(minY)..\(maxY)]")
    print("Dimensions: \(maxX - minX + 1) x \(maxY - minY + 1)")

    // Check the 4 corners
    let corners = [
        Point(x: minX, y: minY), Point(x: minX, y: maxY),
        Point(x: maxX, y: minY), Point(x: maxX, y: maxY)
    ]

    print("\n4 corners validation:")
    for corner in corners {
        let valid = isValidTile(corner)
        let isRed = redSet.contains(corner)
        let isBoundary = boundary.contains(corner)
        let isInterior = !isRed && !isBoundary && valid

        print("  (\(corner.x),\(corner.y)): valid=\(valid) [red=\(isRed) boundary=\(isBoundary) interior=\(isInterior)]")
    }

    // Sample check some interior points
    print("\nSampling interior points (checking 100 random points):")
    var invalidCount = 0
    var sampleCount = 0
    let maxSamples = 100

    let width = maxX - minX + 1
    let height = maxY - minY + 1

    for _ in 0..<maxSamples {
        let x = Int.random(in: minX...maxX)
        let y = Int.random(in: minY...maxY)
        let p = Point(x: x, y: y)

        if !isValidTile(p) {
            invalidCount += 1
            if invalidCount <= 10 {
                print("  INVALID point found: (\(x),\(y))")
            }
        }
        sampleCount += 1
    }

    print("\nSample results: \(invalidCount) invalid out of \(sampleCount) sampled")

    if invalidCount > 0 {
        print("\n⚠️ This rectangle has invalid tiles!")
        print("The largest-by-area rectangle is NOT fully valid.")
        print("Need to check all tiles for each rectangle candidate.")
    } else {
        print("\n✓ Sampled points are all valid")
        print("But this is only a sample - need full check to be certain")
    }
}

// Now find largest VALID rectangle (checking smaller areas first for speed)
print("\n\nFinding largest VALID rectangle (with full tile checking)...")
print("Testing rectangles with area <= 100,000 tiles for speed...")

struct Rectangle {
    let corner1: Point
    let corner2: Point
    let area: Int
}

var rectangles: [Rectangle] = []
for i in 0..<redTiles.count {
    for j in (i+1)..<redTiles.count {
        let tile1 = redTiles[i]
        let tile2 = redTiles[j]
        let width = abs(tile1.x - tile2.x) + 1
        let height = abs(tile1.y - tile2.y) + 1
        let area = width * height

        if area <= 100000 {
            rectangles.append(Rectangle(corner1: tile1, corner2: tile2, area: area))
        }
    }
}

rectangles.sort { $0.area > $1.area }

print("Testing \(rectangles.count) rectangles (area <= 100k)")

func isRectangleValid(_ corner1: Point, _ corner2: Point) -> Bool {
    let minX = min(corner1.x, corner2.x)
    let maxX = max(corner1.x, corner2.x)
    let minY = min(corner1.y, corner2.y)
    let maxY = max(corner1.y, corner2.y)

    for y in minY...maxY {
        for x in minX...maxX {
            if !isValidTile(Point(x: x, y: y)) {
                return false
            }
        }
    }
    return true
}

var checked = 0
for rect in rectangles {
    checked += 1
    if checked % 1000 == 0 {
        print("Checked \(checked) rectangles...")
    }

    if isRectangleValid(rect.corner1, rect.corner2) {
        print("\n✓ Found largest valid rectangle (area <= 100k)")
        print("Area: \(rect.area)")
        print("Corners: (\(rect.corner1.x),\(rect.corner1.y)) to (\(rect.corner2.x),\(rect.corner2.y))")
        break
    }
}

print("\nAnalysis complete.")
