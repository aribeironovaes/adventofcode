# Advent of Code 2025 - Day 1: Secret Entrance

## Problem Summary

We need to open a secret entrance with a circular safe dial. The dial has 100 positions (0-99) and starts at position 50. We receive rotation instructions and must count how many times position 0 is reached.

### Part 1: Count Times Landing on 0

Count how many times the dial **lands on position 0** after completing a rotation.

**Example**: Starting at 50
```
L68: 50 → 82 (doesn't land on 0)
R48: 82 → 30 (doesn't land on 0)
L30: 30 → 0  (lands on 0!)  count = 1
```

### Part 2: Count Every Click Through 0 (Method 0x434C49434B)

Count **every time the dial passes through or lands on position 0** during any rotation, including mid-rotation crossings.

**Example**: Starting at 50
```
L68: 50 → 82 (passes through 0 once)  count = 1
R48: 82 → 30                           count = 1
R48: 30 → 78                           count = 1
R60: 78 → 38 (passes through 0 once)  count = 2
```

### Key Difference

**Part 1**: Only counts when a rotation **ends** on 0
**Part 2**: Counts **every click** through 0 during the entire rotation

---

## Examples

### Part 1 Sample

Starting at position 50:
```
L68: 50 → 82
L30: 82 → 52
R48: 52 → 0    ← lands on 0 (count = 1)
L5:  0 → 95
R60: 95 → 55
L55: 55 → 0    ← lands on 0 (count = 2)
L1:  0 → 99
L99: 99 → 0    ← lands on 0 (count = 3)
R14: 0 → 14
L82: 14 → 32
```

**Total**: 3 ✅

### Part 2 Sample

Starting at position 50:
```
L68: 50 → 82  (passes through 0 once)     count = 1
L30: 82 → 52                               count = 1
R48: 52 → 0   (lands on 0)                 count = 2
L5:  0 → 95                                count = 2
R60: 95 → 55  (passes through 0 once)     count = 3
L55: 55 → 0   (lands on 0)                 count = 4
L1:  0 → 99                                count = 4
L99: 99 → 0   (passes through 0 once)     count = 5
R14: 0 → 14                                count = 5
L82: 14 → 32  (passes through 0 once)     count = 6
```

**Total**: 6 ✅

---

## Solution Approach

### Part 1 Algorithm: Simple Check

After each rotation, check if the final position is 0:

```swift
func rotate(_ rotation: Rotation) {
    switch rotation.direction {
    case .left:
        currentPosition = (currentPosition - rotation.distance) % 100
        if currentPosition < 0 {
            currentPosition += 100
        }
    case .right:
        currentPosition = (currentPosition + rotation.distance) % 100
    }

    if currentPosition == 0 {
        timesLandedOnZero += 1
    }
}
```

**Complexity**: O(1) per rotation

### Part 2 Algorithm: Count Crossings

Count how many times we pass through 0 mathematically:

```swift
func countClicksThroughZero(from start: Int, distance: Int, direction: Direction) -> Int {
    // Complete rotations always pass through 0
    let completeRotations = distance / 100
    var count = completeRotations

    // Check if partial rotation crosses 0
    let remaining = distance % 100

    switch direction {
    case .right:
        // Right: crosses if start + remaining >= 100
        if start + remaining >= 100 {
            count += 1
        }
    case .left:
        // Left: crosses if start <= remaining and start > 0
        // (we go to 0 or negative and wrap)
        if start > 0 && start <= remaining {
            count += 1
        }
    }

    return count
}
```

**How it works**:
1. **Complete rotations**: distance ÷ 100 gives full circles (each passes through 0 once)
2. **Partial rotation**: Check if remaining distance crosses 0
   - Right: crosses if start + remaining ≥ 100
   - Left: crosses if start ≤ remaining (goes through 0 or negative)
   - Exception: Don't count if already starting at 0

**Complexity**: O(1) per rotation

### Example Calculations

**Right rotation from 95, distance 60:**
- Complete rotations: 60 ÷ 100 = 0
- Remaining: 60 % 100 = 60
- Check: 95 + 60 = 155 ≥ 100 ✓
- Count: 0 + 1 = **1**

**Left rotation from 50, distance 68:**
- Complete rotations: 68 ÷ 100 = 0
- Remaining: 68 % 100 = 68
- Check: 50 > 0 AND 50 ≤ 68 ✓
- Count: 0 + 1 = **1**

**Edge case - R1000 from position 50:**
- Complete rotations: 1000 ÷ 100 = 10
- Remaining: 0
- Returns to position 50
- Count: **10**

---

## Results

### Part 1: Times Landing on 0

**Sample Input:**
- Expected: 3
- Got: 3 ✓
- Status: PASSED

**Actual Puzzle Input:**
- Answer: **1029** ✅

### Part 2: Every Click Through 0

**Sample Input:**
- Expected: 6
- Got: 6 ✓
- Status: PASSED

**Actual Puzzle Input:**
- Answer: **5892** ✅

---

## Code Structure

```
Day1-Puzzle1-Secret Entrance/
├── Sources/
│   ├── SafeDial.swift       # Core dial rotation logic
│   │   ├── rotate()                  # Part 1: simple rotation
│   │   ├── processRotations()        # Part 1: count landings
│   │   ├── rotatePart2()             # Part 2: rotation with counting
│   │   └── processRotationsPart2()   # Part 2: count all crossings
│   ├── Rotation.swift       # Symlink to ../../Utilities/
│   ├── InputReader.swift    # Symlink to ../../Utilities/
│   └── main.swift           # Entry point (runs both parts)
├── Inputs/
│   └── input.txt            # Puzzle input
├── Package.swift
└── .gitignore
```

---

## How to Run

```bash
cd "2025/Day1-Puzzle1-Secret Entrance"
swift run
```

Or compile directly:
```bash
swiftc Sources/*.swift -o solve
./solve
```

---

## Key Implementation Details

### Circular Arithmetic

The dial wraps around:
- Position 0 - 1 = 99 (left from 0)
- Position 99 + 1 = 0 (right from 99)

Swift's modulo handles this with a caveat:
```swift
currentPosition = (currentPosition - distance) % 100
if currentPosition < 0 {
    currentPosition += 100  // Swift's modulo can be negative
}
```

### Part 2: Mathematical Crossing Detection

Instead of simulating each click, we calculate crossings:

1. **Count complete circles**: Each 100-click rotation crosses 0 once
2. **Check partial rotation**: Does the remaining distance cross 0?
3. **Handle edge cases**: Starting at 0 shouldn't count as crossing

This is O(1) instead of O(distance), crucial for large distances like R10000.

---

## Complexity Analysis

**Part 1:**
- Time: O(n) where n is number of rotations
- Space: O(1)
- Each rotation is O(1) regardless of distance

**Part 2:**
- Time: O(n) where n is number of rotations
- Space: O(1)
- Each rotation is O(1) regardless of distance

Both parts handle large distances efficiently through mathematical calculation.

---

## Learning Points

1. **Modular Arithmetic**: Circular data structures use modulo operations
2. **Mathematical Optimization**: Avoid simulating when you can calculate
3. **Edge Cases**: Starting position matters (don't double-count)
4. **Code Organization**: Shared utilities via symlinks prevent duplication
5. **Problem Evolution**: Part 2 extends Part 1 with more granular counting

---

## Comparison: Part 1 vs Part 2

| Aspect | Part 1 | Part 2 |
|--------|--------|--------|
| What to count | Rotations ending on 0 | Every click through 0 |
| Sample answer | 3 | 6 |
| Actual answer | 1029 | 5892 |
| Algorithm | Check final position | Count crossings mathematically |
| Complexity | O(1) per rotation | O(1) per rotation |

Part 2 counts more because it includes mid-rotation crossings that Part 1 ignores.

---

## Why Part 2 Algorithm Works

**Insight**: We don't need to simulate each click. We can determine mathematically:

1. **Complete rotations**: Always cross 0 exactly once per 100 clicks
2. **Partial rotations**: Cross 0 if the path from start to end includes position 0

**Correctness**:
- Right: Start + remaining ≥ 100 means we cross from 99 to 0
- Left: Start ≤ remaining means we go negative and wrap through 0
- Special case: If start = 0, we don't count (already at 0)

This approach is critical for performance when distances can be thousands of clicks.

---

Day 1 complete! 🎄
