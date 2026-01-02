#!/usr/bin/env swift

import Foundation

let inputPath = "/Users/angeloribeiro/Development/adventofcode/inputDay12.txt"

guard let content = try? String(contentsOfFile: inputPath, encoding: .utf8) else {
    print("Failed to read input file")
    exit(1)
}

// Calculate area of a shape (count of # characters)
func shapeArea(_ shapeLines: [String]) -> Int {
    var count = 0
    for line in shapeLines {
        for char in line {
            if char == "#" {
                count += 1
            }
        }
    }
    return count
}

// Parse shapes and calculate their areas
var shapeAreas: [Int: Int] = [:]
let lines = content.split(separator: "\n").map { String($0) }
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

        shapeAreas[shapeIndex] = shapeArea(shapeLines)
    } else {
        i += 1
    }
}

print("Shape areas: \(shapeAreas)")

// Check regions
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

        // Calculate total area needed
        var totalAreaNeeded = 0
        for (shapeIdx, count) in counts.enumerated() {
            if let area = shapeAreas[shapeIdx] {
                totalAreaNeeded += count * area
            }
        }

        let regionArea = width * height

        // Cheap feasibility check: if total area fits, consider it valid
        if totalAreaNeeded <= regionArea {
            validRegions += 1
        }
    }
}

print("\nRegions that can fit all presents: \(validRegions)")
