#!/usr/bin/env swift
import Foundation

// Solve Part 2 using greedy + simple optimization
// For each counter, repeatedly add 1 using the button that affects the most "needed" counters
func solvePart2Greedy(buttons: [[Int]], joltage: [Int]) -> Int {
    let numCounters = joltage.count
    var counters = [Int](repeating: 0, count: numCounters)
    var totalPresses = 0

    while counters != joltage {
        var bestButton = -1
        var bestScore = -1.0

        // Find button that makes best progress
        for (buttonIdx, button) in buttons.enumerated() {
            var score = 0.0
            var canHelp = false

            for counter in button {
                if counter < numCounters {
                    let need = joltage[counter] - counters[counter]
                    if need > 0 {
                        score += 1.0  // This button helps
                        canHelp = true
                    } else if need < 0 {
                        // Would overshoot - bad
                        score = -1000.0
                        break
                    }
                }
            }

            if canHelp && score > bestScore {
                bestScore = score
                bestButton = buttonIdx
            }
        }

        if bestButton == -1 {
            // No valid button found
            return Int.max
        }

        // Press the best button
        for counter in buttons[bestButton] {
            if counter < numCounters {
                counters[counter] += 1
            }
        }
        totalPresses += 1

        // Safety check
        if totalPresses > 10000 {
            return Int.max
        }
    }

    return totalPresses
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

print("Solving Part 2 with greedy approach...\n")

for (idx, line) in lines.enumerated() {
    let machineNum = idx + 1
    guard let (_, buttons, joltage) = parseMachine(String(line)) else {
        continue
    }

    let presses = solvePart2Greedy(buttons: buttons, joltage: joltage)
    if presses != Int.max {
        totalPressesP2 += presses
        if machineNum <= 3 || machineNum > 167 {
            print("Machine \(machineNum): \(presses) presses")
        }
    } else {
        print("Machine \(machineNum): FAILED")
    }
}

print("\n=== Part 2 Answer ===")
print("Total presses: \(totalPressesP2)")
