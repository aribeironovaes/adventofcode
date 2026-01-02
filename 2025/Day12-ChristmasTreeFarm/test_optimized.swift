#!/usr/bin/env swift

import Foundation

let inputPath = "test_input.txt"

guard let content = try? String(contentsOfFile: inputPath, encoding: .utf8) else {
    print("Failed to read input file")
    exit(1)
}

struct Point: Hashable {
    let r: Int
    let c: Int
}

typealias Shape = Set<Point>

func parseShapes(_ lines: [String]) -> [Int: [Shape]] {
    var shapes: [Int: [Shape]] = [:]
    var i = 0

    while i < lines.count {
        let line = lines[i]

        if line.contains(":") && !line.contains("x") {
            let parts = line.split(separator: ":")
            guard let shapeIndex = Int(parts[0].trimmingCharacters(in: .whitespaces)) else {
                i += 1
                continue
            }

            var shapeLines: [String] = []
            i += 1
            while i < lines.count && !lines[i].isEmpty && !lines[i].contains(":") {
                shapeLines.append(lines[i])
                i += 1
            }

            var points: Set<Point> = []
            for (r, row) in shapeLines.enumerated() {
                for (c, char) in row.enumerated() {
                    if char == "#" {
                        points.insert(Point(r: r, c: c))
                    }
                }
            }

            shapes[shapeIndex] = generateVariants(points)
        } else {
            i += 1
        }
    }

    return shapes
}

func generateVariants(_ shape: Shape) -> [Shape] {
    var variants: Set<Shape> = []
    var current = shape

    for _ in 0..<4 {
        variants.insert(normalize(current))
        current = rotate90(current)
    }

    current = flipHorizontal(shape)
    for _ in 0..<4 {
        variants.insert(normalize(current))
        current = rotate90(current)
    }

    return Array(variants)
}

func normalize(_ shape: Shape) -> Shape {
    guard let minR = shape.map({ $0.r }).min(),
          let minC = shape.map({ $0.c }).min() else {
        return shape
    }
    return Set(shape.map { Point(r: $0.r - minR, c: $0.c - minC) })
}

func rotate90(_ shape: Shape) -> Shape {
    return Set(shape.map { Point(r: $0.c, c: -$0.r) })
}

func flipHorizontal(_ shape: Shape) -> Shape {
    return Set(shape.map { Point(r: $0.r, c: -$0.c) })
}

func canPlace(_ shape: Shape, at: Point, grid: [[Bool]], width: Int, height: Int) -> Bool {
    for p in shape {
        let r = at.r + p.r
        let c = at.c + p.c
        if r < 0 || r >= height || c < 0 || c >= width || grid[r][c] {
            return false
        }
    }
    return true
}

func place(_ shape: Shape, at: Point, grid: inout [[Bool]]) {
    for p in shape {
        grid[at.r + p.r][at.c + p.c] = true
    }
}

func remove(_ shape: Shape, at: Point, grid: inout [[Bool]]) {
    for p in shape {
        grid[at.r + p.r][at.c + p.c] = false
    }
}

func findFirstEmpty(_ grid: [[Bool]], width: Int, height: Int) -> Point? {
    for r in 0..<height {
        for c in 0..<width {
            if !grid[r][c] {
                return Point(r: r, c: c)
            }
        }
    }
    return nil
}

func canFitAllPresentsOptimized(
    presents: [(shapeIdx: Int, variants: [Shape])],
    presentIndex: Int,
    grid: inout [[Bool]],
    width: Int,
    height: Int
) -> Bool {
    if presentIndex >= presents.count {
        return true
    }

    guard let emptyPos = findFirstEmpty(grid, width: width, height: height) else {
        return presentIndex >= presents.count
    }

    let (_, variants) = presents[presentIndex]

    for variant in variants {
        if canPlace(variant, at: emptyPos, grid: grid, width: width, height: height) {
            place(variant, at: emptyPos, grid: &grid)

            if canFitAllPresentsOptimized(
                presents: presents,
                presentIndex: presentIndex + 1,
                grid: &grid,
                width: width,
                height: height
            ) {
                return true
            }

            remove(variant, at: emptyPos, grid: &grid)
        }
    }

    return false
}

let lines = content.split(separator: "\n").map { String($0) }
let shapes = parseShapes(lines)

var validRegions = 0

for line in lines {
    if line.contains("x") && line.contains(":") {
        let parts = line.split(separator: ":")
        let dimensions = parts[0].split(separator: "x")
        guard dimensions.count == 2,
              let width = Int(dimensions[0]),
              let height = Int(dimensions[1]) else {
            continue
        }

        let counts = parts[1]
            .split(separator: " ")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        var presents: [(shapeIdx: Int, variants: [Shape])] = []
        for (shapeIdx, count) in counts.enumerated() {
            guard let variants = shapes[shapeIdx] else { continue }
            for _ in 0..<count {
                presents.append((shapeIdx, variants))
            }
        }

        var grid = Array(repeating: Array(repeating: false, count: width), count: height)

        if canFitAllPresentsOptimized(
            presents: presents,
            presentIndex: 0,
            grid: &grid,
            width: width,
            height: height
        ) {
            validRegions += 1
        }
    }
}

print("Regions that can fit all presents: \(validRegions)")
print("Expected: 2")
