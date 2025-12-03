# Advent of Code 2025 - Day 2 Part 1: Gift Shop

## Problem Summary

A young Elf accidentally added invalid product IDs to the gift shop database. We need to identify and sum up all the invalid IDs in given ranges.

### What Makes an ID Invalid?

An invalid ID is one where **some sequence of digits is repeated exactly twice**.

**Examples:**
- `55` → "5" repeated twice → Invalid ✓
- `6464` → "64" repeated twice → Invalid ✓
- `123123` → "123" repeated twice → Invalid ✓
- `101` → Odd length, can't be split evenly → Valid
- `1234` → Split into "12" and "34" (not equal) → Valid

### Key Rules

1. IDs must have **even length** to potentially be invalid
2. Split the ID string in half and compare both halves
3. No leading zeroes (but since we work with numbers, this is automatic)

---

## Solution Approach

### Algorithm

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

### Example Walkthrough

For the range `11-22`:
```
11 → "11" → "1" == "1" → Invalid (sum: 11)
12 → "12" → "1" != "2" → Valid
13 → "13" → "1" != "3" → Valid
...
22 → "22" → "2" == "2" → Invalid (sum: 11 + 22 = 33)
```

For the range `95-115`:
```
95-98 → Not repeated patterns
99 → "99" → "9" == "9" → Invalid (sum: 99)
100-115 → Odd length or not repeated
```

For the range `998-1012`:
```
1010 → "1010" → "10" == "10" → Invalid (sum: 1010)
```

---

## Results

### Sample Input
- **Expected**: 1227775554
- **Got**: 1227775554 ✓
- **Status**: PASSED

Breaking down the sample:
- `11-22`: Invalid IDs: 11, 22 (sum: 33)
- `95-115`: Invalid IDs: 99 (sum: 99)
- `998-1012`: Invalid IDs: 1010 (sum: 1010)
- `1188511880-1188511890`: Invalid IDs: 1188511885 (sum: 1188511885)
- `222220-222224`: Invalid IDs: 222222 (sum: 222222)
- `1698522-1698528`: No invalid IDs
- `446443-446449`: Invalid IDs: 446446 (sum: 446446)
- `38593856-38593862`: Invalid IDs: 38593859 (sum: 38593859)
- Remaining ranges: Various invalid IDs
- **Total**: 1227775554

### Actual Puzzle Input
- **Answer**: **13919717792** ✅

---

## Code Structure

```
Day2-Puzzle1-Gift Shop/
├── Sources/
│   ├── GiftShop.swift       # Core logic for detecting invalid IDs
│   ├── InputReader.swift    # Simple file reader utility
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

### Pattern Detection

The core algorithm is simple but effective:

1. **Convert to string**: `String(id)` automatically handles no leading zeros
2. **Check even length**: Only even-length numbers can be repeated patterns
3. **Split and compare**: Use `prefix()` and `suffix()` to get each half
4. **String comparison**: Swift's `==` operator works perfectly for string halves

### Range Processing

```swift
static func sumInvalidIDs(in range: ClosedRange<Int>) -> Int {
    var sum = 0
    for id in range {
        if isInvalidID(id) {
            sum += id
        }
    }
    return sum
}
```

The solution iterates through all IDs in each range. While some ranges are large (100,000+ numbers), the check is O(log n) per number (for string conversion), making it efficient enough.

### Input Parsing

```swift
static func parseRanges(from input: String) -> [ClosedRange<Int>] {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: ",")
        .compactMap { parseRange(String($0)) }
}
```

Handles comma-separated ranges and converts them to Swift's `ClosedRange<Int>` type.

---

## Complexity Analysis

- **Time**: O(n × log m) where n is total IDs across all ranges, m is average ID size
- **Space**: O(1) - only stores running sum
- **Actual runtime**: < 1 second for the puzzle input

---

## Learning Points

1. **Pattern Recognition**: Detecting repeated sequences by string splitting
2. **Modular Arithmetic**: Understanding digit patterns in numbers
3. **Swift Ranges**: Using `ClosedRange<Int>` for inclusive ranges
4. **String Operations**: Efficient use of `prefix()` and `suffix()`
5. **File I/O**: Path resolution for reading input files

---

Ready for Part 2! 🎄
