import Foundation

let inputPath = "Inputs/test.txt"
guard let content = try? String(contentsOfFile: inputPath, encoding: .utf8) else {
    print("Failed to read input")
    exit(1)
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

let lines = content.split(separator: "\n").map { String($0) }
var redTiles: [Point] = []

for line in lines {
    let coords = line.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    guard coords.count == 2 else { continue }
    redTiles.append(Point(x: coords[0], y: coords[1]))
}

func area(_ p1: Point, _ p2: Point) -> Int {
    return (abs(p1.x - p2.x) + 1) * (abs(p1.y - p2.y) + 1)
}

// CORRECT ALGORITHM from Python code
func isValid(_ i: Int, _ j: Int) -> Bool {
    let x1 = min(redTiles[i].x, redTiles[j].x)
    let x2 = max(redTiles[i].x, redTiles[j].x)
    let y1 = min(redTiles[i].y, redTiles[j].y)
    let y2 = max(redTiles[i].y, redTiles[j].y)

    for k in 0..<redTiles.count {
        let x = redTiles[k].x
        let y = redTiles[k].y

        // Get previous vertex (wraps around)
        let kPrev = (k - 1 + redTiles.count) % redTiles.count
        let xp = redTiles[kPrev].x
        let yp = redTiles[kPrev].y

        // Check 1: No vertex strictly inside rectangle
        if x1 < x && x < x2 && y1 < y && y < y2 {
            return false
        }

        // Check 2: Edge crosses left boundary (x == x1)
        if x1 < x && x < x2 && y <= y1 && y1 < yp {
            return false
        }
        if x1 < x && x < x2 && yp <= y1 && y1 < y {
            return false
        }

        // Check 3: Edge crosses right/top boundary (y == y1 or x == x1)
        if y1 < y && y < y2 && x <= x1 && x1 < xp {
            return false
        }
        if y1 < y && y < y2 && xp <= x1 && x1 < x {
            return false
        }
    }

    return true
}

print("Finding largest rectangles...")

var maxArea1 = 0
var maxArea2 = 0
var maxI1 = 0, maxJ1 = 0
var maxI2 = 0, maxJ2 = 0

for i in 0..<redTiles.count {
    for j in 0..<i {
        let a = area(redTiles[i], redTiles[j])

        // Part 1: Just find max area
        if a > maxArea1 {
            maxArea1 = a
            maxI1 = i
            maxJ1 = j
        }

        // Part 2: Find max area with validation
        if a > maxArea2 && isValid(i, j) {
            maxArea2 = a
            maxI2 = i
            maxJ2 = j
        }
    }

    if i % 50 == 0 {
        print("Progress: \(i)/\(redTiles.count)")
    }
}

print("\n=== RESULTS ===")
print("Part 1: \(maxArea1) at (\(redTiles[maxI1].x),\(redTiles[maxI1].y)) to (\(redTiles[maxJ1].x),\(redTiles[maxJ1].y))")
print("Part 2: \(maxArea2) at (\(redTiles[maxI2].x),\(redTiles[maxI2].y)) to (\(redTiles[maxJ2].x),\(redTiles[maxJ2].y))")
