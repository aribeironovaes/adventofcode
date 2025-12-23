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

// Test just 3.5M and 4M
let limits = [3500000, 4000000]

for limit in limits {
    print("Testing limit: \(limit)")
    var maxValid = 0

    for i in 0..<redTiles.count {
        for j in (i+1)..<redTiles.count {
            let t1 = redTiles[i]
            let t2 = redTiles[j]
            let w = abs(t1.x - t2.x) + 1
            let h = abs(t1.y - t2.y) + 1
            let area = w * h

            if area > limit || area <= maxValid {
                continue
            }

            let minX = min(t1.x, t2.x)
            let maxX = max(t1.x, t2.x)
            let minY = min(t1.y, t2.y)
            let maxY = max(t1.y, t2.y)

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
                print("  Found: \(area)")
            }
        }
    }

    print("Limit \(limit): Answer = \(maxValid)\n")
}
