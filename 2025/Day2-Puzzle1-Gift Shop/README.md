# Advent of Code 2025 - Day 2: Gift Shop

## Problem Summary

A young Elf accidentally added invalid product IDs to the gift shop database. We need to identify and sum up all the invalid IDs in given ranges.

### Part 1: Exactly Twice Repetition

An invalid ID is one where **some sequence of digits is repeated exactly twice**.

**Examples:**
- `55` → "5" repeated twice → Invalid ✓
- `6464` → "64" repeated twice → Invalid ✓
- `123123` → "123" repeated twice → Invalid ✓
- `101` → Odd length, can't be split evenly → Valid
- `1234` → Split into "12" and "34" (not equal) → Valid

### Part 2: At Least Twice Repetition

An invalid ID is one where **some sequence of digits is repeated at least twice** (2 or more times).

**Examples:**
- `55` → "5" repeated twice → Invalid ✓
- `123123123` → "123" repeated three times → Invalid ✓
- `1111111` → "1" repeated seven times → Invalid ✓
- `12341234` → "1234" repeated twice → Invalid ✓
- `1212121212` → "12" repeated five times → Invalid ✓

### Key Rules

1. **Part 1**: Must be even length and split exactly in half with matching parts
2. **Part 2**: Try all possible pattern lengths; if any pattern repeats 2+ times, it's invalid
3. No leading zeroes (but since we work with numbers, this is automatic)

---

## Solution Approach

### Part 1 Algorithm

```swift
func isInvalidID(_ id: Int) -> Bool {
    let str = String(id)
    let len = str.count

    // Must be even length to be a repeated pattern
    guard len % 2 == 0 else { return false }

    // Split in half and compare
    let mid = len / 2
    let firstHalf = str.prefix(mid)
    let secondHalf = str.suffix(mid)

    return firstHalf == secondHalf
}
```

### Part 2 Algorithm

```swift
func isInvalidIDPart2(_ id: Int) -> Bool {
    let str = String(id)
    let len = str.count

    // Try all possible pattern lengths from 1 to len/2
    for patternLength in 1...(len / 2) {
        guard len % patternLength == 0 else { continue }

        let pattern = str.prefix(patternLength)

        // Check if entire string is this pattern repeated
        var isRepeated = true
        var index = patternLength

        while index < len {
            let start = str.index(str.startIndex, offsetBy: index)
            let end = str.index(start, offsetBy: patternLength)
            let chunk = str[start..<end]

            if chunk != pattern {
                isRepeated = false
                break
            }

            index += patternLength
        }

        if isRepeated {
            return true
        }
    }

    return false
}
```

### Example Walkthrough

**Part 1 - Range `95-115`:**
```
99 → "99" → "9" == "9" → Invalid (sum: 99)
111 → "111" → Odd length → Valid
```

**Part 2 - Range `95-115`:**
```
99 → "99" → "9" repeated twice → Invalid (sum: 99)
111 → "111" → "1" repeated three times → Invalid (sum: 99 + 111 = 210)
```

**Part 2 - Range `565653-565659`:**
```
565656 → "565656" → "56" repeated three times → Invalid (sum: 565656)
```

---

## Results

### Part 1: Exactly Twice Repetition

**Sample Input:**
- **Expected**: 1227775554
- **Got**: 1227775554 ✓
- **Status**: PASSED

**Actual Puzzle Input:**
- **Answer**: **13919717792** ✅

### Part 2: At Least Twice Repetition

**Sample Input:**
- **Expected**: 4174379265
- **Got**: 4174379265 ✓
- **Status**: PASSED

Breaking down the sample (differences from Part 1):
- `11-22`: Still 11, 22 (both "exactly twice")
- `95-115`: Now includes 99 AND 111 (111 = "1" three times)
- `998-1012`: Now includes 999 AND 1010 (999 = "9" three times)
- `565653-565659`: Now includes 565656 ("56" three times)
- `824824821-824824827`: Now includes 824824824 ("824" three times)
- `2121212118-2121212124`: Now includes 2121212121 ("21" five times)

**Actual Puzzle Input:**
- **Answer**: **14582313461** ✅

---

## Code Structure

```
Day2-Puzzle1-Gift Shop/
├── Sources/
│   ├── GiftShop.swift       # Core logic for both parts
│   │   ├── isInvalidID()           # Part 1: exactly twice
│   │   └── isInvalidIDPart2()      # Part 2: at least twice
│   ├── InputReader.swift    # Simple file reader utility
│   └── main.swift           # Entry point (runs both parts)
├── Inputs/
│   ├── sample.txt           # Sample test data
│   └── input.txt            # Actual puzzle input
├── Package.swift
└── .gitignore
```

---

## How to Run

```bash
cd "2025/Day2-Puzzle1-Gift Shop"
swift run
```

Or compile directly:
```bash
swiftc Sources/*.swift -o solve
./solve
```

---

## Key Implementation Details

### Part 1: Simple Split

The algorithm simply checks if the number can be split in half with identical parts. This is O(log n) per number where n is the ID value.

### Part 2: Pattern Detection

The algorithm tries all possible pattern lengths:

1. **Divisibility Check**: Only try pattern lengths that divide evenly into the total length
2. **Pattern Extraction**: Get the first chunk as the candidate pattern
3. **Validation**: Check if all subsequent chunks match the pattern
4. **Early Exit**: Return true as soon as any valid pattern is found

**Complexity for each ID:**
- Try at most `len/2` pattern lengths
- For each pattern, check at most `len` characters
- Overall: O(len²) per ID, but practically very fast due to early exits

### Range Processing

Both parts iterate through all IDs in each range. While some ranges are large (100,000+ numbers), the checks are efficient:

```swift
static func sumInvalidIDsPart2(in range: ClosedRange<Int>) -> Int {
    var sum = 0
    for id in range {
        if isInvalidIDPart2(id) {
            sum += id
        }
    }
    return sum
}
```

---

## Complexity Analysis

### Part 1
- **Time**: O(n × log m) where n is total IDs, m is average ID size
- **Space**: O(1) - only stores running sum

### Part 2
- **Time**: O(n × log²m) where n is total IDs, m is average ID size
- **Space**: O(1) - only stores running sum

**Actual runtime**: ~1-2 seconds for the puzzle input

---

## Comparison: Part 1 vs Part 2

| Range | Part 1 Invalid IDs | Part 2 Invalid IDs | Difference |
|-------|-------------------|-------------------|------------|
| 11-22 | 11, 22 | 11, 22 | Same |
| 95-115 | 99 | 99, 111 | +111 |
| 998-1012 | 1010 | 999, 1010 | +999 |
| 565653-565659 | None | 565656 | +565656 |
| 824824821-824824827 | None | 824824824 | +824824824 |
| 2121212118-2121212124 | None | 2121212121 | +2121212121 |

Part 2 finds more invalid IDs because it catches patterns repeated 3+ times, not just exactly twice.

---

## Learning Points

1. **Pattern Recognition**: Detecting repeated sequences by trying all divisor lengths
2. **String Manipulation**: Using `prefix()`, `suffix()`, and string indexing in Swift
3. **Algorithm Optimization**: Early exits when pattern is found
4. **Modular Code**: Separate functions for Part 1 and Part 2 logic
5. **Testing**: Validating with known sample outputs before solving

---

Day 2 complete! 🎄

