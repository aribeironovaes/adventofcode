# Advent of Code 2025 - Day 3: Lobby

## Problem Summary

The elevators are offline due to an electrical surge. To power the escalator, we need to configure emergency batteries. Each battery bank has batteries labeled with joltage ratings (1-9), and we need to find the maximum joltage each bank can produce.

### Part 1: Select 2 Batteries

- **Battery Banks**: Each line of input represents a bank of batteries
- **Selection Rule**: Turn on exactly TWO batteries per bank
- **Joltage Calculation**: The joltage is the 2-digit number formed by concatenating the selected batteries' digits in order
- **Cannot Rearrange**: Batteries must stay in their original positions
- **Goal**: Find the maximum joltage from each bank and sum them all

### Part 2: Select 12 Batteries

After hitting the "joltage limit safety override" button, we now need more power:

- **Selection Rule**: Turn on exactly TWELVE batteries per bank
- **Joltage Calculation**: The joltage is the 12-digit number formed by concatenating the selected batteries' digits in order
- **Challenge**: We need to skip some batteries while maximizing the resulting number
- **Goal**: Find the maximum 12-digit joltage from each bank and sum them all

---

## Examples

### Part 1 Examples

**Bank: `987654321111111`**
- Turn on positions 0 and 1 (digits 9 and 8) → **98 jolts**

**Bank: `811111111111119`**
- Turn on positions 0 and 14 (digits 8 and 9) → **89 jolts**

**Total Part 1**: 98 + 89 + 78 + 92 = **357**

### Part 2 Examples

**Bank: `987654321111111`** (15 digits, select 12, skip 3)
- Turn on everything except three 1s at the end → **987654321111**
- Skipped positions: 12, 13, 14

**Bank: `811111111111119`** (15 digits, select 12, skip 3)
- Turn on everything except three 1s in the middle → **811111111119**
- Skipped some 1s to keep the 8 at start and 9 at end

**Bank: `234234234234278`** (15 digits, select 12, skip 3)
- Skip a 2, a 3, and another 2 near the start → **434234234278**
- This maximizes the leading digits

**Bank: `818181911112111`** (15 digits, select 12, skip 3)
- Skip some 1s near the front to keep larger digits → **888911112111**

**Total Part 2**: 987654321111 + 811111111119 + 434234234278 + 888911112111 = **3121910778619**

---

## Solution Approach

### Part 1 Algorithm: Try All Pairs

```swift
func maximumJoltage(from bank: String) -> Int {
    let batteries = Array(bank)
    var maxJoltage = 0

    // Try all pairs (i, j) where i < j
    for i in 0..<(batteries.count - 1) {
        for j in (i + 1)..<batteries.count {
            let joltage = Int(String(batteries[i]) + String(batteries[j]))!
            maxJoltage = max(maxJoltage, joltage)
        }
    }

    return maxJoltage
}
```

**Complexity**: O(n²) per bank

### Part 2 Algorithm: Greedy Selection

The key insight is to use a **greedy algorithm** that selects digits to maximize the result while maintaining order.

```swift
func maximumJoltageWith12(from bank: String) -> Int {
    let digits = Array(bank)
    let n = digits.count
    let k = 12

    var result = ""
    var sourcePos = 0

    // For each position in the 12-digit result
    for resultPos in 0..<k {
        let remaining = k - resultPos
        let latestStart = n - remaining

        // Find the maximum digit in valid range
        var maxDigit = Character("0")
        var maxPos = sourcePos

        for pos in sourcePos...latestStart {
            if digits[pos] > maxDigit {
                maxDigit = digits[pos]
                maxPos = pos
            }
        }

        result.append(maxDigit)
        sourcePos = maxPos + 1
    }

    return Int(result)!
}
```

**How it works**:
1. **For each position** in the 12-digit result
2. **Calculate how many digits remain** to fill
3. **Find the latest starting position** that still leaves enough digits
4. **Select the maximum digit** in that range
5. **Move past the selected digit** and repeat

**Example walkthrough** for `818181911112111`:

```
Position 0: Look at [0:3], max is 8 at position 0, take it → "8"
Position 1: Look at [1:4], max is 8 at position 2, take it → "88"
Position 2: Look at [3:5], max is 8 at position 4, take it → "888"
Position 3: Look at [5:6], max is 9 at position 6, take it → "8889"
Position 4-11: Take remaining 8 digits → "888911112111"
```

**Complexity**: O(n × k) = O(n × 12) = O(n) per bank

---

## Results

### Part 1: Select 2 Batteries

**Sample Input:**
- Expected: 357
- Got: 357 ✓
- Status: PASSED

**Actual Puzzle Input:**
- Battery Banks: 200
- Answer: **17301** ✅

### Part 2: Select 12 Batteries

**Sample Input:**
- Expected: 3121910778619
- Got: 3121910778619 ✓
- Status: PASSED

**Actual Puzzle Input:**
- Battery Banks: 200
- Answer: **172162399742349** ✅

---

## Code Structure

```
Day3-Puzzle1-Lobby/
├── Sources/
│   ├── BatteryBank.swift    # Core joltage calculation logic
│   │   ├── maximumJoltage()        # Part 1: select 2
│   │   └── maximumJoltageWith12()  # Part 2: select 12
│   ├── InputReader.swift    # File reading utility
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

### Part 1: Brute Force

Try all possible pairs and keep the maximum. Simple and effective for small k (k=2).

### Part 2: Greedy Algorithm

The greedy approach works because:
1. We want to maximize the leftmost digits first (they have higher place value)
2. At each position, we can look ahead and pick the best available digit
3. We must ensure we leave enough digits for the remaining positions

**Why greedy works**:
- If we have a choice between placing a 9 or an 8 at position 0, we always choose 9
- Any future digit selection cannot compensate for a suboptimal early digit
- The constraint ensures we always have enough digits remaining

### Complexity Analysis

**Part 1:**
- Time: O(n²) per bank where n is bank length
- Space: O(1)
- For n ≈ 100, this is ~10,000 operations per bank

**Part 2:**
- Time: O(n × k) = O(n × 12) per bank
- Space: O(k) = O(12) for result string
- For n ≈ 100, this is ~1,200 operations per bank

**Overall:**
- 200 banks × 100 digits each
- Part 1: ~2,000,000 operations
- Part 2: ~240,000 operations
- Runtime: < 1 second for both parts

---

## Learning Points

1. **Greedy Algorithms**: Part 2 demonstrates classic greedy subsequence selection
2. **Place Value**: Higher positions have exponentially more impact on the final number
3. **Constraint Management**: Ensuring we leave enough elements for future selections
4. **Algorithm Optimization**: Part 2 is actually faster than Part 1 despite producing larger numbers
5. **Problem Transformation**: From "select k items" to "find lexicographically largest subsequence"

---

## Why Part 2 Greedy Works

The problem is equivalent to finding the **lexicographically largest subsequence** of length 12.

**Proof sketch**:
- Suppose we make a suboptimal choice at position i (choose digit d instead of d')
- Where d < d' and both maintain valid remaining elements
- No future choices can compensate because:
  - Position i has place value 10^(11-i)
  - All future positions have place value < 10^(11-i)
  - The difference (d' - d) × 10^(11-i) > sum of all future possible improvements

Therefore, greedy locally optimal = globally optimal.

---

Day 3 complete! 🎄
