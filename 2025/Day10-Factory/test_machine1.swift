#!/usr/bin/env swift
import Foundation

// Machine 1: [.###] (0,2,3) (1,2) (0) (0,2) (1,3) {32,23,39,9}
// Lights: 0=off, 1=on, 2=on, 3=on
// Buttons: B0=(0,2,3), B1=(1,2), B2=(0), B3=(0,2), B4=(1,3)
// Joltage: counter[0]=32, counter[1]=23, counter[2]=39, counter[3]=9

let buttons = [[0,2,3], [1,2], [0], [0,2], [1,3]]
let joltage = [32, 23, 39, 9]

print("Machine 1 Analysis:")
print("Buttons:")
for (i, button) in buttons.enumerated() {
    print("  B\(i): affects counters \(button)")
}
print("\nTarget joltage: \(joltage)")

// Try to find what combination gives these values
// Let x_i = number of times we press button i
// We need: sum of button presses to match joltage

// counter[0] is affected by buttons 0, 2, 3
// counter[1] is affected by buttons 1, 4
// counter[2] is affected by buttons 0, 1, 3
// counter[3] is affected by buttons 0, 4

print("\nEquations:")
print("counter[0] = x0 + x2 + x3 = 32")
print("counter[1] = x1 + x4 = 23")
print("counter[2] = x0 + x1 + x3 = 39")
print("counter[3] = x0 + x4 = 9")

// From equation 4: x0 + x4 = 9
// From equation 2: x1 + x4 = 23
// Subtracting: x1 - x0 = 14, so x1 = x0 + 14

// From equation 1: x0 + x2 + x3 = 32
// From equation 3: x0 + x1 + x3 = 39
// Subtracting: x1 - x2 = 7
// Since x1 = x0 + 14, we have: x0 + 14 - x2 = 7, so x2 = x0 + 7

// From equation 1: x0 + (x0 + 7) + x3 = 32
// So: 2*x0 + 7 + x3 = 32
// So: x3 = 25 - 2*x0

// From equation 4: x4 = 9 - x0

// Check: x1 + x4 = (x0 + 14) + (9 - x0) = 23 ✓

// So we need x3 = 25 - 2*x0 >= 0, meaning x0 <= 12.5, so x0 <= 12
// And x4 = 9 - x0 >= 0, meaning x0 <= 9

// Let's minimize total = x0 + x1 + x2 + x3 + x4
// = x0 + (x0+14) + (x0+7) + (25-2*x0) + (9-x0)
// = x0 + x0 + 14 + x0 + 7 + 25 - 2*x0 + 9 - x0
// = 55

print("\nSolution: Total presses = 55 (independent of x0 choice!)")
print("For example, with x0=0:")
print("  x0=0, x1=14, x2=7, x3=25, x4=9")
print("  Verify: counter[0] = 0+0+7 = 0+7 = 7 ❌")

// Wait, let me recalculate
print("\nRecalculating with x0=0:")
let x0=0, x1=14, x2=7, x3=25, x4=9
var counters = [0, 0, 0, 0]
// Press button 0 (affects 0,2,3) x0=0 times: no change
// Press button 1 (affects 1,2) x1=14 times
counters[1] += 14
counters[2] += 14
print("After B1×14: \(counters)")
// Press button 2 (affects 0) x2=7 times
counters[0] += 7
print("After B2×7: \(counters)")
// Press button 3 (affects 0,2) x3=25 times
counters[0] += 25
counters[2] += 25
print("After B3×25: \(counters)")
// Press button 4 (affects 1,3) x4=9 times
counters[1] += 9
counters[3] += 9
print("After B4×9: \(counters)")
print("Target: \(joltage)")
print("Match: \(counters == joltage)")
