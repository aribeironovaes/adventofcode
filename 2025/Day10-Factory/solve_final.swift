#!/usr/bin/env swift
import Foundation

// Solve system of linear Diophantine equations using enumeration
// This is essentially an integer linear programming problem
func solvePart2Linear(buttons: [[Int]], joltage: [Int]) -> Int? {
    let numButtons = buttons.count
    let numCounters = joltage.count

    // Create coefficient matrix
    // matrix[counter][button] = 1 if button affects counter
    var matrix: [[Int]] = Array(repeating: Array(repeating: 0, count: numButtons), count: numCounters)

    for (buttonIdx, button) in buttons.enumerated() {
        for counter in button {
            if counter < numCounters {
                matrix[counter][buttonIdx] = 1
            }
        }
    }

    // Use a smarter search: try combinations but with better pruning
    // For each button, limit presses to the max joltage value
    let maxPresses = joltage.max() ?? 100

    var bestSolution: Int? = nil

    // Try a more targeted approach: solve incrementally
    // Start by finding if ANY solution exists using small values
    func search(_ buttonIdx: Int, _ presses: [Int], _ counters: [Int]) {
        if buttonIdx == numButtons {
            if counters == joltage {
                let total = presses.reduce(0, +)
                if bestSolution == nil || total < bestSolution! {
                    bestSolution = total
                }
            }
            return
        }

        // Prune: if we already exceeded target on any counter, skip
        for i in 0..<numCounters {
            if counters[i] > joltage[i] {
                return
            }
        }

        // Prune: if current total already >= best, skip
        if let best = bestSolution, presses.reduce(0, +) >= best {
            return
        }

        // Try pressing this button 0 to maxPresses times
        let limit = min(maxPresses, bestSolution ?? Int.max)
        for times in 0...limit {
            var newCounters = counters
            var valid = true

            for counter in buttons[buttonIdx] {
                if counter < numCounters {
                    newCounters[counter] += times
                    if newCounters[counter] > joltage[counter] {
                        valid = false
                        break
                    }
                }
            }

            if valid {
                var newPresses = presses
                newPresses.append(times)
                search(buttonIdx + 1, newPresses, newCounters)
            } else {
                break  // No point trying more presses
            }
        }
    }

    search(0, [], Array(repeating: 0, count: numCounters))
    return bestSolution
}

// Parse input
func parseMachine(_ line: String) -> (target: [Int], buttons: [[Int]], joltage: [Int])? {
    guard let lightsStart = line.firstIndex(of: "["),
          let lightsEnd = line.firstIndex(of: "]") else {
        return nil
    }

    let lightsStr = line[line.index(after: lightsStart)..<lightsEnd]
    let target = lightsStr.map { $0 == "#" ? 1 : 0 }

    var buttons: [[Int]] = []
    var i = line.index(after: lightsEnd)

    while i < line.endIndex {
        if line[i] == "(" {
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

    var joltage: [Int] = []
    if let joltStart = line.lastIndex(of: "{"),
       let joltEnd = line.lastIndex(of: "}") {
        let joltStr = line[line.index(after: joltStart)..<joltEnd]
        joltage = joltStr.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    }

    return (target, buttons, joltage)
}

// Read input
guard let content = try? String(contentsOfFile: "/Users/angeloribeiro/Development/adventofcode/inputDay10.txt", encoding: .utf8) else {
    print("Failed to read input")
    exit(1)
}

let lines = content.split(separator: "\n").filter { !$0.isEmpty }

var totalPressesP2 = 0
var solvedCount = 0

print("Solving Part 2 with linear solver...\n")

for (idx, line) in lines.enumerated() {
    let machineNum = idx + 1
    guard let (_, buttons, joltage) = parseMachine(String(line)) else {
        continue
    }

    if let presses = solvePart2Linear(buttons: buttons, joltage: joltage) {
        totalPressesP2 += presses
        solvedCount += 1
        if machineNum <= 5 || machineNum > 165 {
            print("Machine \(machineNum): \(presses) presses")
        } else if machineNum == 6 {
            print("...")
        }
    } else {
        print("Machine \(machineNum): FAILED")
    }
}

print("\n=== Part 2 Answer ===")
print("Solved: \(solvedCount)/\(lines.count) machines")
print("Total presses: \(totalPressesP2)")
