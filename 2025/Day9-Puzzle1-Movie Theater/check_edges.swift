import Foundation

let input = try\! String(contentsOfFile: "Inputs/input.txt")
let lines = input.split(separator: "\n")
var coords: [(Int, Int)] = []

for line in lines {
    let parts = line.split(separator: ",")
    let x = Int(parts[0])\!
    let y = Int(parts[1])\!
    coords.append((x, y))
}

print("Checking if all edges are axis-aligned:")
var diagonalCount = 0
for i in 0..<coords.count {
    let start = coords[i]
    let end = coords[(i + 1) % coords.count]
    
    let isHorizontal = start.1 == end.1
    let isVertical = start.0 == end.0
    
    if \!isHorizontal && \!isVertical {
        print("Edge \(i): (\(start.0),\(start.1)) -> (\(end.0),\(end.1)) is DIAGONAL\!")
        diagonalCount += 1
    }
}

if diagonalCount == 0 {
    print("All edges are axis-aligned (horizontal or vertical)")
} else {
    print("Found \(diagonalCount) diagonal edges")
}
