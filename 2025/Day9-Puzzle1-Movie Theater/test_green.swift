import Foundation

struct Point: Hashable {
    let x: Int, y: Int
}

guard let content = try? String(contentsOfFile: "Inputs/input.txt") else {
    print("Failed to read input")
    exit(1)
}

let lines = content.split(separator: "\n").map { String($0) }
var redTiles: [Point] = []

for line in lines {
    let coords = line.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    guard coords.count == 2 else { continue }
    redTiles.append(Point(x: coords[0], y: coords[1]))
}

print("Red tiles: \(redTiles.count)")

// Count boundary tiles
var boundaryCount = 0
for i in 0..<redTiles.count {
    let start = redTiles[i]
    let end = redTiles[(i + 1) % redTiles.count]
    
    if start.x == end.x {
        boundaryCount += abs(end.y - start.y) + 1
    } else if start.y == end.y {
        boundaryCount += abs(end.x - start.x) + 1
    }
}

print("Boundary tiles (with red): \(boundaryCount)")
print("Boundary-only (green): \(boundaryCount - redTiles.count)")

// Bounding box
let minX = redTiles.map { $0.x }.min()\!
let maxX = redTiles.map { $0.x }.max()\!
let minY = redTiles.map { $0.y }.min()\!
let maxY = redTiles.map { $0.y }.max()\!

print("Bounding box: (\(minX),\(minY)) to (\(maxX),\(maxY))")
print("Bounding box size: \((maxX - minX + 1)) x \((maxY - minY + 1)) = \((maxX - minX + 1) * (maxY - minY + 1))")
