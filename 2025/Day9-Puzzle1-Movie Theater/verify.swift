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

print("Red tiles (polygon vertices in order):")
for (i, tile) in redTiles.enumerated() {
    print("  \(i): (\(tile.x), \(tile.y))")
}

// The example says answer is 24 for rectangle between (9,5) and (2,3)
let c1 = Point(x: 9, y: 5)
let c2 = Point(x: 2, y: 3)
let w = abs(c1.x - c2.x) + 1
let h = abs(c1.y - c2.y) + 1
print("\nExpected answer rectangle: (\(c1.x),\(c1.y)) to (\(c2.x),\(c2.y))")
print("  Width: \(w), Height: \(h), Area: \(w * h)")

// Check: are all 4 corners of this rectangle red or on polygon?
let corners = [
    Point(x: 2, y: 3), Point(x: 2, y: 5),
    Point(x: 9, y: 3), Point(x: 9, y: 5)
]

let redSet = Set(redTiles)
print("\n4 corners:")
for corner in corners {
    let isRed = redSet.contains(corner)
    print("  (\(corner.x),\(corner.y)): \(isRed ? "RED" : "not red")")
}
