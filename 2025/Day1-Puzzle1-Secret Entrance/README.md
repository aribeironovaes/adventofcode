# Advent of Code 2025 - Day 1: Secret Entrance

## Problem Summary

You arrive at the North Pole's secret entrance, but the password has been changed. To get in, you need to solve a puzzle involving a safe with a circular dial.

### The Safe Dial

- The dial has **100 positions** numbered from **0 to 99**
- The dial starts at position **50**
- The dial is **circular**: going left from 0 wraps to 99, and going right from 99 wraps to 0

### Instructions Format

You receive a list of rotation instructions, one per line:
- Format: `<Direction><Distance>`
- **Direction**:
  - `L` = Left (toward lower numbers)
  - `R` = Right (toward higher numbers)
- **Distance**: How many clicks to rotate

### Examples

1. **From position 11:**
   - `R8` → position 19 (11 + 8 = 19)
   - Then `L19` → position 0 (19 - 19 = 0)

2. **Wrapping examples:**
   - From 0: `L10` → position 95 (wraps around: 0 - 10 + 100 = 95)
   - From 5: `L10` → position 95 (5 - 10 = -5, which wraps to 95)
   - From 99: `R5` → position 4 (99 + 5 = 104, mod 100 = 4)

### The Goal

**Count how many times the dial lands on position 0 after any rotation.**

The password is this count!

---

## Solution Approach

### Algorithm

1. **Start at position 50**
2. **For each rotation instruction:**
   - Parse the direction (L or R) and distance
   - Update the position:
     - **Left**: `position = (position - distance) % 100`
     - **Right**: `position = (position + distance) % 100`
   - Handle negative wrapping (Swift's modulo can return negative values)
   - **Check if position == 0**, if so, increment counter
3. **Return the counter**

### Key Implementation Details

#### Circular Modulo Arithmetic

The trickiest part is handling the circular nature of the dial:

```swift
// For LEFT rotations:
currentPosition = (currentPosition - rotation.distance) % dialSize

// Swift's modulo can return negative values, so we need to handle that:
if currentPosition < 0 {
    currentPosition += dialSize  // Wrap to positive range
}

// For RIGHT rotations (simpler):
currentPosition = (currentPosition + rotation.distance) % dialSize
```

**Why the special handling for negatives?**

In Swift (and many programming languages), `-5 % 100` returns `-5`, not `95`. We need to add 100 to get the correct positive position.

#### Example Walkthrough

Let's trace through the sample input:

```
Starting position: 50

1. L68: 50 - 68 = -18 → -18 + 100 = 82
2. L30: 82 - 30 = 52
3. R48: 52 + 48 = 100 → 100 % 100 = 0  ✓ (count = 1)
4. L5:  0 - 5 = -5 → -5 + 100 = 95
5. R60: 95 + 60 = 155 → 155 % 100 = 55
6. L55: 55 - 55 = 0  ✓ (count = 2)
7. L1:  0 - 1 = -1 → -1 + 100 = 99
8. L99: 99 - 99 = 0  ✓ (count = 3)
9. R14: 0 + 14 = 14
10. L82: 14 - 82 = -68 → -68 + 100 = 32

Total times at 0: 3 ✓
```

---

## Swift Implementation

The solution uses three main components:

### 1. **Rotation Struct**
Parses and stores rotation instructions (L/R and distance).

```swift
struct Rotation {
    let direction: Direction  // .left or .right
    let distance: Int

    enum Direction {
        case left
        case right
    }
}
```

### 2. **SafeDial Class**
Manages the dial state and processes rotations.

```swift
class SafeDial {
    private(set) var currentPosition: Int
    private(set) var timesLandedOnZero: Int = 0
    private let dialSize = 100

    func rotate(_ rotation: Rotation) {
        // Update position based on direction
        // Check if we landed on 0
    }
}
```

### 3. **Input Processing**
Parses the input string into Rotation objects.

---

## Results

### Sample Input
- **Expected**: 3
- **Got**: 3 ✓
- **Status**: PASSED

### Actual Puzzle Input
- **Answer**: **1029**
- **Status**: SOLVED

---

## How to Run

### Option 1: Run the standalone script
```bash
swift solve.swift
```

### Option 2: Open in Xcode
1. Open `SecretEntrance.xcodeproj` in Xcode
2. Build and run (⌘R)

### Option 3: Use Swift Package Manager
```bash
swift build
swift run
```

---

## Learning Points

### 1. Modulo Arithmetic with Negative Numbers
This problem teaches an important lesson about modulo operations:
- In mathematics: `-5 mod 100 = 95`
- In Swift/most languages: `-5 % 100 = -5`

**Solution**: When result is negative, add the modulus:
```swift
if result < 0 {
    result += modulus
}
```

### 2. Circular Data Structures
The dial is a perfect example of a circular buffer or ring. This pattern appears often in:
- Game development (circular levels)
- Time calculations (hours wrap after 23)
- Buffer management
- Clock arithmetic

### 3. State Tracking
We need to track:
- Current position (the state)
- Count of zeros (the answer)

This is a simple state machine pattern.

### 4. Parsing Structured Input
Breaking down each line into:
- Direction character (L/R)
- Numeric distance

This teaches input validation and parsing techniques.

---

## Complexity Analysis

- **Time Complexity**: O(n) where n is the number of rotations
  - We process each rotation exactly once
  - Each rotation is O(1) (just arithmetic)

- **Space Complexity**: O(n)
  - We store all n rotations in memory
  - Could be optimized to O(1) by processing line-by-line

---

## Possible Extensions

1. **Part 2 Predictions**: Advent of Code usually has a Part 2. It might ask:
   - What if we need to find a specific sequence?
   - Track all unique positions visited?
   - Find cycles in the dial positions?

2. **Optimizations**:
   - Stream processing (don't load all rotations at once)
   - Detect cycles (if rotations repeat)

3. **Variations**:
   - Different dial sizes (not just 0-99)
   - Multiple target positions
   - Reverse: given a sequence of positions, find the rotations

---

## Project Structure

```
Day1-Puzzle1-Secret Entrance/
├── Package.swift           # Swift Package Manager config
├── Sources/
│   └── main.swift         # Full solution with file I/O
├── Inputs/
│   ├── sample.txt         # Example input
│   └── input.txt          # Actual puzzle input
├── solve.swift            # Standalone executable script
└── README.md             # This file
```

---

## Author Notes

This solution was created for Advent of Code 2025, Day 1. The code emphasizes:
- **Clarity**: Well-commented and structured
- **Education**: Explains the "why" not just the "how"
- **Swift idioms**: Proper use of optionals, structs, and classes

Happy coding! 🎄
