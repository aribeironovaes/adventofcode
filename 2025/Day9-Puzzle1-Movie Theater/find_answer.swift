import Foundation

let inputPath = "Inputs/input.txt"
guard let content = try? String(contentsOfFile: inputPath, encoding: .utf8) else {
    print("Failed to read input")
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

// Build boundary
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
        rectangles.append(Rectangle(corner1: tile1, corner2: tile2, area: area))
    }
}

rectangles.sort { $0.area > $1.area }

print("Total rectangles: \(rectangles.count)")

func isRectangleValid(_ corner1: Point, _ corner2: Point, areaLimit: Int) -> Bool {
    let minX = min(corner1.x, corner2.x)
    let maxX = max(corner1.x, corner2.x)
    let minY = min(corner1.y, corner2.y)
    let maxY = max(corner1.y, corner2.y)

    let area = (maxX - minX + 1) * (maxY - minY + 1)
    if area > areaLimit {
        return false
    }

    for y in minY...maxY {
        for x in minX...maxX {
            if !isValidTile(Point(x: x, y: y)) {
                return false
            }
        }
    }
    return true
}

// Try increasing limits
let limits = [100000, 150000, 200000, 250000, 350000, 500000, 750000, 1000000, 1500000, 2000000, 3000000, 4000000, 5000000, 7500000, 10000000]

for limit in limits {
    print("\n--- Testing with limit: \(limit) ---")
    var maxValid = 0
    var checked = 0

    for rect in rectangles {
        if rect.area > limit {
            continue
        }

        checked += 1
        if checked % 5000 == 0 {
            print("Checked \(checked), current max: \(maxValid)")
        }

        if isRectangleValid(rect.corner1, rect.corner2, areaLimit: limit) {
            if rect.area > maxValid {
                maxValid = rect.area
                print("Found valid: \(rect.area) at check #\(checked)")
            }
        }
    }

    print("Limit \(limit): Max valid area = \(maxValid)")

    // If we found nothing new, we've likely peaked
    if maxValid < limit / 2 {
        print("Answer appears stable at: \(maxValid)")
        break
    }
}
