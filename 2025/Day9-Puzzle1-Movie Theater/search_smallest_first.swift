import Foundation

let inputPath = "Inputs/input.txt"
guard let content = try? String(contentsOfFile: inputPath, encoding: .utf8) else {
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
        for y in min(start.y, end.y)...max(start.y, end.y) {
            boundary.insert(Point(x: start.x, y: y))
        }
    } else if start.y == end.y {
        for x in min(start.x, end.x)...max(start.x, end.x) {
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

// NEW APPROACH: Search from SMALLEST to LARGEST
// Keep track of the largest valid rectangle found
print("Generating all rectangles...")
var rectangles: [(Point, Point, Int)] = []

for i in 0..<redTiles.count {
    for j in (i+1)..<redTiles.count {
        let t1 = redTiles[i]
        let t2 = redTiles[j]
        let area = (abs(t1.x - t2.x) + 1) * (abs(t1.y - t2.y) + 1)
        rectangles.append((t1, t2, area))
    }
}

// Sort ASCENDING (smallest first)
rectangles.sort { $0.2 < $1.2 }

print("Total rectangles: \(rectangles.count)")
print("Smallest: \(rectangles.first!.2), Largest: \(rectangles.last!.2)")

var maxValid = 0
var checked = 0
let startTime = Date()

print("\nSearching from smallest to largest...")

for (c1, c2, area) in rectangles {
    checked += 1

    if checked % 10000 == 0 {
        let elapsed = Date().timeIntervalSince(startTime)
        print("Checked \(checked)/\(rectangles.count) - area \(area) - max so far: \(maxValid) - time: \(Int(elapsed))s")
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

    if valid && area > maxValid {
        maxValid = area
        print("  ✓ New max: \(area) at (\(c1.x),\(c1.y)) to (\(c2.x),\(c2.y))")
    }
}

let elapsed = Date().timeIntervalSince(startTime)
print("\n=== COMPLETED in \(Int(elapsed))s ===")
print("Answer: \(maxValid)")
