#!/usr/bin/env swift
import Foundation

// Solve Part 2 using BFS to find shortest path
func solvePart2BFS(buttons: [[Int]], joltage: [Int]) -> Int? {
    let numCounters = joltage.count

    // State: current counter values
    struct State: Hashable {
        let counters: [Int]
    }

    let startState = State(counters: [Int](repeating: 0, count: numCounters))
    let targetState = State(counters: joltage)

    if startState == targetState {
        return 0
    }

    var queue: [(State, Int)] = [(startState, 0)]
    var visited = Set<State>()
    visited.insert(startState)

    var queueIndex = 0
    let maxPresses = joltage.reduce(0, +) * 2  // Safety limit

    while queueIndex < queue.count {
        let (currentState, presses) = queue[queueIndex]
        queueIndex += 1

        if presses > maxPresses {
            continue
        }

        // Try pressing each button
        for button in buttons {
            var newCounters = currentState.counters
            var valid = true

            for counter in button {
                if counter < numCounters {
                    newCounters[counter] += 1
                    if newCounters[counter] > joltage[counter] {
                        valid = false
                        break
                    }
                }
            }

            if !valid {
                continue
            }

            let newState = State(counters: newCounters)

            if newState == targetState {
                return presses + 1
            }

            if !visited.contains(newState) {
                visited.insert(newState)
                queue.append((newState, presses + 1))
            }
        }
    }

    return nil
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

print("Solving Part 2 with BFS approach...\n")

for (idx, line) in lines.enumerated() {
    let machineNum = idx + 1
    guard let (_, buttons, joltage) = parseMachine(String(line)) else {
        continue
    }

    if let presses = solvePart2BFS(buttons: buttons, joltage: joltage) {
        totalPressesP2 += presses
        solvedCount += 1
        if machineNum <= 3 || machineNum > 167 {
            print("Machine \(machineNum): \(presses) presses")
        }
    } else {
        print("Machine \(machineNum): FAILED")
    }
}

print("\n=== Part 2 Answer ===")
print("Solved: \(solvedCount)/\(lines.count) machines")
print("Total presses: \(totalPressesP2)")
