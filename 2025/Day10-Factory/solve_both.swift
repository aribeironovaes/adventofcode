#!/usr/bin/env swift
import Foundation

// PART 1: Binary (GF2) - each button pressed 0 or 1 times
func solvePart1(buttons: [[Int]], target: [Int]) -> Int? {
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

        if lights == target {
            if minPresses == nil || presses < minPresses! {
                minPresses = presses
            }
        }
    }

    return minPresses
}

// PART 2: Integer counters - buttons can be pressed multiple times
// This is a system of linear Diophantine equations
// We want to find non-negative integers x_i such that:
// sum(x_i * button_i) = target
// and minimize sum(x_i)
func solvePart2(buttons: [[Int]], joltage: [Int]) -> Int? {
    let numButtons = buttons.count
    let numCounters = joltage.count

    // Greedy approach: repeatedly press the button that makes most progress
    var counters = [Int](repeating: 0, count: numCounters)
    var totalPresses = 0
    let maxIterations = joltage.reduce(0, +) * 2  // Safety limit

    for _ in 0..<maxIterations {
        // Check if we're done
        if counters == joltage {
            return totalPresses
        }

        // Find the button that maximizes progress without overshooting
        var bestButton = -1
        var bestScore = -1

        for b in 0..<numButtons {
            var canPress = true
            var score = 0

            for counter in buttons[b] {
                if counter < numCounters {
                    if counters[counter] >= joltage[counter] {
                        canPress = false
                        break
                    }
                    score += 1  // Count how many counters this button helps
                }
            }

            if canPress && score > bestScore {
                bestScore = score
                bestButton = b
            }
        }

        if bestButton == -1 {
            // No button can make progress, failed
            return nil
        }

        // Press the best button
        for counter in buttons[bestButton] {
            if counter < numCounters {
                counters[counter] += 1
            }
        }
        totalPresses += 1
    }

    return nil  // Failed to converge
}

// Better approach: Use linear programming / Simplex-like method
// For small systems, we can use a more systematic approach
func solvePart2Optimal(buttons: [[Int]], joltage: [Int]) -> Int? {
    let numButtons = buttons.count
    let numCounters = joltage.count

    // Convert buttons to matrix form
    var matrix: [[Int]] = []
    for button in buttons {
        var row = [Int](repeating: 0, count: numCounters)
        for counter in button {
            if counter < numCounters {
                row[counter] = 1
            }
        }
        matrix.append(row)
    }

    // Try different combinations systematically
    // For each counter, find which buttons affect it
    var bestSolution: [Int]? = nil
    var minPresses = Int.max

    // Use a bounded search: no button needs to be pressed more than max(joltage)
    let maxPressesPerButton = joltage.max() ?? 0

    func search(buttonIndex: Int, presses: [Int], counters: [Int], totalPresses: Int) {
        if buttonIndex == numButtons {
            if counters == joltage && totalPresses < minPresses {
                minPresses = totalPresses
                bestSolution = presses
            }
            return
        }

        // Prune: if already worse than best, skip
        if totalPresses >= minPresses {
            return
        }

        // Try pressing this button 0 to maxPressesPerButton times
        for times in 0...maxPressesPerButton {
            var newCounters = counters
            var valid = true

            for counter in buttons[buttonIndex] {
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
                newPresses[buttonIndex] = times
                search(buttonIndex: buttonIndex + 1,
                      presses: newPresses,
                      counters: newCounters,
                      totalPresses: totalPresses + times)
            }
        }
    }

    let initialPresses = [Int](repeating: 0, count: numButtons)
    let initialCounters = [Int](repeating: 0, count: numCounters)
    search(buttonIndex: 0, presses: initialPresses, counters: initialCounters, totalPresses: 0)

    return bestSolution != nil ? minPresses : nil
}

// Parse a machine specification
func parseMachine(_ line: String) -> (target: [Int], buttons: [[Int]], joltage: [Int])? {
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

    // Extract joltage requirements {...}
    var joltage: [Int] = []
    if let joltStart = line.lastIndex(of: "{"),
       let joltEnd = line.lastIndex(of: "}") {
        let joltStr = line[line.index(after: joltStart)..<joltEnd]
        joltage = joltStr.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    }

    return (target, buttons, joltage)
}

// Read input file
guard let content = try? String(contentsOfFile: "/Users/angeloribeiro/Development/adventofcode/inputDay10.txt", encoding: .utf8) else {
    print("Failed to read input")
    exit(1)
}

let lines = content.split(separator: "\n").filter { !$0.isEmpty }

var totalPressesPart1 = 0
var totalPressesPart2 = 0
var machineNum = 0

print("Processing machines...\n")

for line in lines {
    machineNum += 1
    guard let (target, buttons, joltage) = parseMachine(String(line)) else {
        print("Machine \(machineNum): Failed to parse")
        continue
    }

    // Part 1
    if let presses1 = solvePart1(buttons: buttons, target: target) {
        totalPressesPart1 += presses1
    }

    // Part 2
    if let presses2 = solvePart2Optimal(buttons: buttons, joltage: joltage) {
        if machineNum <= 5 {
            print("Machine \(machineNum): Part1=\(solvePart1(buttons: buttons, target: target) ?? -1), Part2=\(presses2)")
        }
        totalPressesPart2 += presses2
    }
}

print("\n=== RESULTS ===")
print("Part 1 (Binary/GF2): \(totalPressesPart1) total presses")
print("Part 2 (Joltage): \(totalPressesPart2) total presses")
