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

// Represent a shape as a set of relative coordinates
typealias Shape = Set<Point>

// Parse shapes from input
func parseShapes(_ lines: [String]) -> [Int: [Shape]] {
    var shapes: [Int: [Shape]] = [:]
    var i = 0

    while i < lines.count {
        let line = lines[i]

        // Check if this is a shape definition line
        if line.contains(":") && !line.contains("x") {
            let parts = line.split(separator: ":")
            guard let shapeIndex = Int(parts[0].trimmingCharacters(in: .whitespaces)) else {
                i += 1
                continue
            }

            // Read shape lines
            var shapeLines: [String] = []
            i += 1
            while i < lines.count && !lines[i].isEmpty && !lines[i].contains(":") {
                shapeLines.append(lines[i])
                i += 1
            }

            // Convert to Point set
            var points: Set<Point> = []
            for (r, row) in shapeLines.enumerated() {
                for (c, char) in row.enumerated() {
                    if char == "#" {
                        points.insert(Point(r: r, c: c))
                    }
                }
            }

            // Generate all rotations and flips
            shapes[shapeIndex] = generateVariants(points)
            print("Shape \(shapeIndex) has \(shapes[shapeIndex]!.count) variants")
        } else {
            i += 1
        }
    }

    return shapes
}

// Generate all unique rotations and flips of a shape
func generateVariants(_ shape: Shape) -> [Shape] {
    var variants: Set<Shape> = []
    var current = shape

    // 4 rotations
    for _ in 0..<4 {
        variants.insert(normalize(current))
        current = rotate90(current)
    }

    // Flip and 4 more rotations
    current = flipHorizontal(shape)
    for _ in 0..<4 {
        variants.insert(normalize(current))
        current = rotate90(current)
    }

    return Array(variants)
}

// Normalize shape to start at (0,0)
func normalize(_ shape: Shape) -> Shape {
    guard let minR = shape.map({ $0.r }).min(),
          let minC = shape.map({ $0.c }).min() else {
        return shape
    }
    return Set(shape.map { Point(r: $0.r - minR, c: $0.c - minC) })
}

// Rotate shape 90 degrees clockwise
func rotate90(_ shape: Shape) -> Shape {
    return Set(shape.map { Point(r: $0.c, c: -$0.r) })
}

// Flip shape horizontally
func flipHorizontal(_ shape: Shape) -> Shape {
    return Set(shape.map { Point(r: $0.r, c: -$0.c) })
}

// Check if shape can be placed at position
func canPlace(_ shape: Shape, at: Point, grid: inout [[Bool]], width: Int, height: Int) -> Bool {
    for p in shape {
        let r = at.r + p.r
        let c = at.c + p.c
        if r < 0 || r >= height || c < 0 || c >= width || grid[r][c] {
            return false
        }
    }
    return true
}

// Place shape on grid
func place(_ shape: Shape, at: Point, grid: inout [[Bool]]) {
    for p in shape {
        grid[at.r + p.r][at.c + p.c] = true
    }
}

// Remove shape from grid
func remove(_ shape: Shape, at: Point, grid: inout [[Bool]]) {
    for p in shape {
        grid[at.r + p.r][at.c + p.c] = false
    }
}

// Try to fit all presents using backtracking
func canFitAllPresents(
    presents: [(shapeIdx: Int, variants: [Shape])],
    presentIndex: Int,
    grid: inout [[Bool]],
    width: Int,
    height: Int
) -> Bool {
    // Base case: all presents placed
    if presentIndex >= presents.count {
        return true
    }

    let (_, variants) = presents[presentIndex]

    // Try each variant of this present
    for variant in variants {
        // Try placing at each position
        for r in 0..<height {
            for c in 0..<width {
                let pos = Point(r: r, c: c)
                if canPlace(variant, at: pos, grid: &grid, width: width, height: height) {
                    place(variant, at: pos, grid: &grid)

                    if canFitAllPresents(
                        presents: presents,
                        presentIndex: presentIndex + 1,
                        grid: &grid,
                        width: width,
                        height: height
                    ) {
                        return true
                    }

                    remove(variant, at: pos, grid: &grid)
                }
            }
        }
    }

    return false
}

// Parse and solve
let lines = content.split(separator: "\n").map { String($0) }
let shapes = parseShapes(lines)

print("\nProcessing regions:")
var validRegions = 0

// Process regions
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

        print("\nRegion \(width)x\(height) with counts: \(counts)")

        // Build list of presents to place
        var presents: [(shapeIdx: Int, variants: [Shape])] = []
        for (shapeIdx, count) in counts.enumerated() {
            guard let variants = shapes[shapeIdx] else { continue }
            for _ in 0..<count {
                presents.append((shapeIdx, variants))
            }
        }

        print("Need to place \(presents.count) presents")

        // Try to fit all presents
        var grid = Array(repeating: Array(repeating: false, count: width), count: height)

        if canFitAllPresents(
            presents: presents,
            presentIndex: 0,
            grid: &grid,
            width: width,
            height: height
        ) {
            print("✓ Can fit all presents")
            validRegions += 1
        } else {
            print("✗ Cannot fit all presents")
        }
    }
}

print("\n=====")
print("Regions that can fit all presents: \(validRegions)")
print("Expected: 2")
