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

print("\nTop 100 rectangles by area:")
for i in 0..<min(100, rectangles.count) {
    let r = rectangles[i]
    print("\(i+1). Area: \(r.area) - (\(r.corner1.x),\(r.corner1.y)) to (\(r.corner2.x),\(r.corner2.y))")
}

print("\nArea ranges:")
let buckets = [100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000]
var counts: [Int] = Array(repeating: 0, count: buckets.count + 1)

for rect in rectangles {
    var placed = false
    for (i, bucket) in buckets.enumerated() {
        if rect.area <= bucket {
            counts[i] += 1
            placed = true
            break
        }
    }
    if !placed {
        counts[buckets.count] += 1
    }
}

for (i, bucket) in buckets.enumerated() {
    print("<= \(bucket): \(counts[i]) rectangles")
}
print("> \(buckets.last!): \(counts[buckets.count]) rectangles")
