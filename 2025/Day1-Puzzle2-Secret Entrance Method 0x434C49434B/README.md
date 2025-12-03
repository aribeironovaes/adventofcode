# Advent of Code 2025 - Day 1 Part 2: Secret Entrance Method 0x434C49434B

## Problem Summary

Part 2 introduces a new password method: **0x434C49434B**. Instead of counting only when the dial **lands on 0 at the end of a rotation**, we now count **every time the dial passes through or lands on 0 during any rotation**.

### The Key Difference

**Part 1:** Count when rotation ends on 0
**Part 2:** Count every click through 0 (including mid-rotation)

### Example Walkthrough

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

**Total:** 6 ✅

### Important Edge Case

A rotation like `R1000` from position 50:
- Makes 10 complete rotations (1000 ÷ 100 = 10)
- Each complete rotation passes through 0 once
- Returns to position 50
- **Total count:** 10

---

## Solution Approach

### Algorithm

The key insight is counting clicks through 0 mathematically:

```swift
func countClicksThroughZero(from start: Int, distance: Int, direction: Direction) -> Int {
    // Complete rotations always pass through 0
    let completeRotations = distance / 100
    var count = completeRotations

    // Check if partial rotation crosses 0
    let remaining = distance % 100

    if direction == .right {
        // Right: crosses if start + remaining >= 100
        if start + remaining >= 100 {
            count += 1
        }
    } else {  // left
        // Left: crosses if start < remaining (goes negative)
        if start < remaining {
            count += 1
        }
    }

    return count
}
```

### Example Calculations

**Right rotation from 95, distance 60:**
- Complete rotations: 60 ÷ 100 = 0
- Remaining: 60 % 100 = 60
- Check: 95 + 60 = 155 >= 100 ✓
- Count: 0 + 1 = **1**

**Left rotation from 50, distance 68:**
- Complete rotations: 68 ÷ 100 = 0
- Remaining: 68 % 100 = 68
- Check: 50 < 68 ✓ (would go to -18, wraps to 82)
- Count: 0 + 1 = **1**

---

## Results

### Sample Input
- **Expected**: 6
- **Got**: 6 ✓
- **Status**: PASSED

### Actual Puzzle Input
- **Answer**: **5892** ✅

---

## Code Structure

```
Day1-Puzzle2-Secret Entrance Method 0x434C49434B/
├── Sources/
│   ├── SafeDial.swift      # Part 2 logic with click counting
│   ├── main.swift          # Entry point
│   ├── Rotation.swift      # Symlink to ../../Utilities/
│   └── InputReader.swift   # Symlink to ../../Utilities/
├── Inputs/
│   ├── sample.txt
│   └── input.txt
├── Package.swift
└── .gitignore
```

---

## How to Run

```bash
cd "2025/Day1-Puzzle2-Secret Entrance Method 0x434C49434B"
swift run
```

Or compile directly:
```bash
swiftc Sources/*.swift -o solve
./solve
```

---

## Comparison with Part 1

| Aspect | Part 1 | Part 2 |
|--------|--------|--------|
| What to count | Rotations ending on 0 | Every click through 0 |
| Sample answer | 3 | 6 |
| Actual answer | 1029 | 5895 |
| Complexity | O(n) | O(n) |

---

## Learning Points

1. **Modular Arithmetic**: Understanding how circular positions wrap
2. **Complete vs Partial Rotations**: Breaking distance into full cycles + remainder
3. **Boundary Crossing**: Detecting when rotation crosses 0
4. **Code Reuse**: Shared utilities (Rotation, InputReader) via symlinks

---

## Project Structure Benefits

### Shared Utilities Folder

```
2025/
├── Utilities/              # Shared code
│   ├── Rotation.swift
│   └── InputReader.swift
├── Day1-Puzzle1-...        # Part 1 (symlinks to Utilities)
└── Day1-Puzzle2-...        # Part 2 (symlinks to Utilities)
```

**Benefits:**
- ✅ No code duplication
- ✅ Single source of truth
- ✅ Easy to maintain
- ✅ Each puzzle is self-contained

---

Ready for Day 2! 🎄
