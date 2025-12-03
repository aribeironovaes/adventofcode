# Advent of Code 2025 - Day 3: Lobby

## Problem Summary

The elevators are offline due to an electrical surge. To power the escalator, we need to configure emergency batteries. Each battery bank has batteries labeled with joltage ratings (1-9), and we need to find the maximum joltage each bank can produce.

### The Challenge

- **Battery Banks**: Each line of input represents a bank of batteries
- **Selection Rule**: Turn on exactly TWO batteries per bank
- **Joltage Calculation**: The joltage is the 2-digit number formed by concatenating the selected batteries' digits in order
- **Cannot Rearrange**: Batteries must stay in their original positions
- **Goal**: Find the maximum joltage from each bank and sum them all

### Examples

**Bank: `987654321111111`**
- Turn on positions 0 and 1 (digits 9 and 8) → **98 jolts**
- This is the maximum because 9 and 8 are the two highest digits we can form in order

**Bank: `811111111111119`**
- Turn on positions 0 and 14 (digits 8 and 9) → **89 jolts**
- Can't get 98 because 9 comes after 8 in the sequence

**Bank: `234234234234278`**
- Turn on positions 13 and 14 (digits 7 and 8) → **78 jolts**

**Bank: `818181911112111`**
- Turn on positions 6 and 11 (digits 9 and 2) → **92 jolts**
- Position 6 has the digit 9, position 11 has the digit 2

**Total**: 98 + 89 + 78 + 92 = **357**

---

## Solution Approach

### Algorithm

The key insight is that we need to try all possible pairs of battery positions and find which pair produces the maximum 2-digit number.

```swift
func maximumJoltage(from bank: String) -> Int {
    let batteries = Array(bank)
    var maxJoltage = 0

    // Try all pairs (i, j) where i < j
    for i in 0..<(batteries.count - 1) {
        for j in (i + 1)..<batteries.count {
            // Form 2-digit number from positions i and j
            let joltage = Int(String(batteries[i]) + String(batteries[j]))!
            maxJoltage = max(maxJoltage, joltage)
        }
    }

    return maxJoltage
}
```

### How It Works

1. **Convert to Array**: Split the bank string into individual digit characters
2. **Try All Pairs**: For each position `i`, try pairing it with every position `j` after it
3. **Form Number**: Concatenate the digits at positions `i` and `j` to form a 2-digit number
4. **Track Maximum**: Keep the highest joltage found
5. **Sum Results**: Add up the maximum from each bank

### Example Walkthrough

For bank `818181911112111`:

```
Position: 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14
Digit:    8  1  8  1  8  1  9  1  1  1  1  2  1  1  1

Some pairs:
(0, 1) → "81" → 81
(0, 6) → "89" → 89
(6, 7) → "91" → 91
(6, 11) → "92" → 92  ← Maximum!
(6, 12) → "91" → 91
```

The maximum is **92** from positions 6 and 11.

---

## Results

### Sample Input

**Banks:**
1. `987654321111111` → 98
2. `811111111111119` → 89
3. `234234234234278` → 78
4. `818181911112111` → 92

**Expected**: 357
**Got**: 357 ✓
**Status**: PASSED

### Actual Puzzle Input

- **Battery Banks**: 200
- **Answer**: **17301** ✅

---

## Code Structure

```
Day3-Puzzle1-Lobby/
├── Sources/
│   ├── BatteryBank.swift    # Core joltage calculation logic
│   ├── InputReader.swift    # File reading utility
│   └── main.swift           # Entry point
├── Inputs/
│   ├── sample.txt           # Sample test data
│   └── input.txt            # Actual puzzle input
├── Package.swift
└── .gitignore
```

---

## How to Run

```bash
cd "2025/Day3-Puzzle1-Lobby"
swift run
```

Or compile directly:
```bash
swiftc Sources/*.swift -o solve
./solve
```

---

## Key Implementation Details

### Pair Generation

The nested loop structure ensures we try all unique pairs:

```swift
for i in 0..<(count - 1) {
    for j in (i + 1)..<count {
        // Process pair (i, j)
    }
}
```

This generates all combinations where `i < j`, ensuring:
- We don't try the same pair twice
- We maintain the order (battery at position i comes before j)
- We check all possible pairs exactly once

### String to Integer Conversion

```swift
let digit1 = String(batteries[i])
let digit2 = String(batteries[j])
let joltageStr = digit1 + digit2
let joltage = Int(joltageStr)!
```

By concatenating strings first, we naturally form the 2-digit number in the correct order.

### Complexity Analysis

**Per Bank:**
- **Time**: O(n²) where n is the length of the bank
- **Space**: O(1) - only store max value

**Overall:**
- **Banks**: 200
- **Average Length**: ~80-100 characters per bank
- **Time**: O(banks × n²) ≈ O(200 × 10,000) = O(2,000,000) operations
- **Space**: O(1) per bank
- **Runtime**: < 1 second

The quadratic time per bank is acceptable because:
1. Each bank is relatively short (~100 characters max)
2. We only have 200 banks
3. The inner operations are simple comparisons

---

## Learning Points

1. **Combinatorics**: Generating all pairs from a sequence
2. **String Manipulation**: Concatenating digits to form numbers
3. **Greedy Approach**: For each bank independently find the maximum
4. **Problem Constraints**: Understanding "in order" means maintaining position order
5. **Optimization**: Sometimes O(n²) is acceptable when n is small

---

## Why This Works

The key insight is that we're looking for the maximum value of the form `XY` where:
- `X` is the digit at some position `i`
- `Y` is the digit at some position `j > i`
- We want to maximize `10*X + Y`

To maximize this:
1. We prefer larger values of `X` (tens digit)
2. For the same `X`, we prefer larger values of `Y` (ones digit)
3. We must maintain the constraint that `i < j` (order matters)

By trying all valid pairs, we guarantee finding the maximum.

---

Day 3 complete! 🎄
