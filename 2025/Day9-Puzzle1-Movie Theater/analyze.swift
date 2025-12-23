import Foundation

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

print("Testing rectangle (9,5) to (2,3) which should be area 24")
print("Corners: (2,3), (2,5), (9,3), (9,5)")
print("")

// Build full green tile set
var greenTiles = Set<Point>()

// Add boundary
for i in 0..<redTiles.count {
    let start = redTiles[i]
    let end = redTiles[(i + 1) % redTiles.count]
    
    if start.x == end.x {
        let minY = min(start.y, end.y)
        let maxY = max(start.y, end.y)
        for y in minY...maxY {
            greenTiles.insert(Point(x: start.x, y: y))
        }
    } else if start.y == end.y {
        let minX = min(start.x, end.x)
        let maxX = max(start.x, end.x)
        for x in minX...maxX {
            greenTiles.insert(Point(x: x, y: start.y))
        }
    }
}

// Ray casting for interior
func isInside(_ point: Point) -> Bool {
    var inside = false
    let n = redTiles.count
    var j = n - 1
    for i in 0..<n {
        let vi = redTiles[i]
        let vj = redTiles[j]
        if ((vi.y > point.y) \!= (vj.y > point.y)) &&
           (point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x) {
            inside.toggle()
        }
        j = i
    }
    return inside
}

let minX = redTiles.map { $0.x }.min()\!
let maxX = redTiles.map { $0.x }.max()\!
let minY = redTiles.map { $0.y }.min()\!
let maxY = redTiles.map { $0.y }.max()\!

for y in minY...maxY {
    for x in minX...maxX {
        let p = Point(x: x, y: y)
        if \!greenTiles.contains(p) && isInside(p) {
            greenTiles.insert(p)
        }
    }
}

print("Total green tiles: \(greenTiles.count)")
print("Total red tiles: \(redTiles.count)")

// Check the 24-area rectangle
let redSet = Set(redTiles)
let validTiles = greenTiles.union(redSet)

print("\nChecking rectangle (2,3) to (9,5):")
var allValid = true
var invalidCount = 0
for y in 3...5 {
    for x in 2...9 {
        let p = Point(x: x, y: y)
        if \!validTiles.contains(p) {
            print("  Invalid tile at (\(x),\(y))")
            allValid = false
            invalidCount += 1
        }
    }
}

if allValid {
    print("  All tiles valid\!")
} else {
    print("  Found \(invalidCount) invalid tiles")
}

// Visualization
print("\nGrid (# = red, . = green, X = other):")
for y in 0...8 {
    var row = ""
    for x in 0...12 {
        let p = Point(x: x, y: y)
        if redSet.contains(p) {
            row += "#"
        } else if greenTiles.contains(p) {
            row += "."
        } else {
            row += " "
        }
    }
    print("\(y): \(row)")
}
