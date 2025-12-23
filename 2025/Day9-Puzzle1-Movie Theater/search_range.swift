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
        // Only consider rectangles in interesting range
        if area >= 3000000 && area <= 20000000 {
            rectangles.append(Rectangle(corner1: tile1, corner2: tile2, area: area))
        }
    }
}

rectangles.sort { $0.area > $1.area }

print("Found \(rectangles.count) rectangles in range 3M-20M")
print("Testing each one...")

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
    if checked % 100 == 0 {
        print("Checked \(checked)/\(rectangles.count)...")
    }

    if isRectangleValid(rect.corner1, rect.corner2) {
        print("\n✓ FOUND VALID RECTANGLE!")
        print("Area: \(rect.area)")
        print("Corners: (\(rect.corner1.x),\(rect.corner1.y)) to (\(rect.corner2.x),\(rect.corner2.y))")
        exit(0)
    }
}

print("\nNo valid rectangle found in 3M-20M range")
