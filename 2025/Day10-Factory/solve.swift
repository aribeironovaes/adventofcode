#!/usr/bin/env swift
import Foundation

// Solves system of linear equations over GF(2) using Gaussian elimination
// Returns minimum number of button presses, or nil if no solution
func solveGF2System(buttons: [[Int]], target: [Int]) -> Int? {
    let numButtons = buttons.count
    let numLights = target.count

    // Create augmented matrix [A | b]
    var matrix = buttons.map { button -> [Int] in
        var row = [Int](repeating: 0, count: numLights)
        for light in button {
            if light < numLights {
                row[light] = 1
            }
        }
        row.append(0) // augmented column (will be set based on target)
        return row
    }

    // Add target to augmented column
    for i in 0..<numButtons {
        matrix[i][numLights] = 0
    }

    // We need to solve: sum(x_i * button_i) = target (mod 2)
    // Rearrange to: sum(x_i * button_i) - target = 0 (mod 2)

    // Transform target into rows
    var targetRow = target
    targetRow.append(1) // RHS = 1 for lights that need to be on

    // Perform Gaussian elimination (forward)
    var pivotRow = 0
    for col in 0..<numLights {
        // Find pivot
        var foundPivot = false
        for row in pivotRow..<numButtons {
            if matrix[row][col] == 1 {
                // Swap rows
                if row != pivotRow {
                    let temp = matrix[pivotRow]
                    matrix[pivotRow] = matrix[row]
                    matrix[row] = temp
                }
                foundPivot = true
                break
            }
        }

        if !foundPivot {
            continue
        }

        // Eliminate column in other rows
        for row in 0..<numButtons {
            if row != pivotRow && matrix[row][col] == 1 {
                for c in 0...numLights {
                    matrix[row][c] ^= matrix[pivotRow][c]
                }
            }
        }

        pivotRow += 1
    }

    // Back substitution: find minimal solution
    // Since we want minimum presses, try greedy approach
    var solution = [Int](repeating: 0, count: numButtons)

    // Try all combinations (brute force for small systems)
    let minPresses = tryAllCombinations(buttons: buttons, target: target)
    return minPresses
}

// Brute force: try all combinations of button presses (0 or 1 each)
func tryAllCombinations(buttons: [[Int]], target: [Int]) -> Int? {
    let numButtons = buttons.count
    let numLights = target.count
    var minPresses: Int? = nil

    // Try all 2^numButtons combinations
    for mask in 0..<(1 << numButtons) {
        var lights = [Int](repeating: 0, count: numLights)
        var presses = 0

        for i in 0..<numButtons {
            if (mask & (1 << i)) != 0 {
                presses += 1
                for light in buttons[i] {
                    if light < numLights {
                        lights[light] ^= 1
                    }
                }
            }
        }

        // Check if this matches target
        if lights == target {
            if minPresses == nil || presses < minPresses! {
                minPresses = presses
            }
        }
    }

    return minPresses
}

// Parse a machine specification
func parseMachine(_ line: String) -> (target: [Int], buttons: [[Int]])? {
    // Extract indicator lights pattern [.##.]
    guard let lightsStart = line.firstIndex(of: "["),
          let lightsEnd = line.firstIndex(of: "]") else {
        return nil
    }

    let lightsStr = line[line.index(after: lightsStart)..<lightsEnd]
    let target = lightsStr.map { $0 == "#" ? 1 : 0 }

    // Extract button specs (...)
    var buttons: [[Int]] = []
    var i = line.index(after: lightsEnd)

    while i < line.endIndex {
        if line[i] == "(" {
            // Find matching )
            var j = line.index(after: i)
            while j < line.endIndex && line[j] != ")" {
                j = line.index(after: j)
            }

            if j < line.endIndex {
                let buttonStr = line[line.index(after: i)..<j]
                let lights = buttonStr.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                buttons.append(lights)
                i = line.index(after: j)
            } else {
                break
            }
        } else {
            i = line.index(after: i)
        }
    }

    return (target, buttons)
}

// Read input file
guard let content = try? String(contentsOfFile: "/Users/angeloribeiro/Development/adventofcode/inputDay10.txt", encoding: .utf8) else {
    print("Failed to read input")
    exit(1)
}

let lines = content.split(separator: "\n").filter { !$0.isEmpty }

var totalPresses = 0
var machineNum = 0

for line in lines {
    machineNum += 1
    guard let (target, buttons) = parseMachine(String(line)) else {
        print("Failed to parse machine \(machineNum)")
        continue
    }

    if let presses = tryAllCombinations(buttons: buttons, target: target) {
        print("Machine \(machineNum): \(presses) presses")
        totalPresses += presses
    } else {
        print("Machine \(machineNum): NO SOLUTION")
    }
}

print("\nTotal button presses: \(totalPresses)")
