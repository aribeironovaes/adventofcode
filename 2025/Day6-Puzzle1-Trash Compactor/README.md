# Day 6: Trash Compactor

## Problem Description

You're helping cephalopods with their math worksheet. The worksheet has numbers arranged in vertical columns with operators at the bottom of each column.

### Part 1: Token-Based Column Reading

Initially, you read the worksheet by treating each whitespace-separated number as belonging to a column.

#### Example

```
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
```

Reading by tokens (whitespace-separated values):
- Column 0: `123, 45, 6` with operator `*` → 123 × 45 × 6 = 33210
- Column 1: `328, 64, 98` with operator `+` → 328 + 64 + 98 = 490
- Column 2: `51, 387, 215` with operator `*` → 51 × 387 × 215 = 4248405
- Column 3: `64, 23, 314` with operator `+` → 64 + 23 + 314 = 401

Grand total: 33210 + 490 + 4248405 + 401 = **4282506**

Wait, that's not the expected answer (4277556)! This led to discovering the actual parsing method.

### Part 2: Cephalopod Math (Character-by-Character, Right-to-Left)

The cephalopods explain their actual math notation:
- Read **right-to-left**, column by column (character positions)
- Each vertical column of digits forms a multi-digit number (reading top to bottom)
- Problems are separated by space columns
- The operator marks the leftmost column of each problem

#### Example (Same Input, Different Interpretation)

```
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
```

Column positions (0-indexed):
```
0123456789012345
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
```

Reading right-to-left by character position:
- **Rightmost problem** (operator at col 12, `+`):
  - Col 14: `4` (top to bottom: 4)
  - Col 13: `431` (top to bottom: 431)
  - Col 12: `623` (top to bottom: 623)
  - Problem: 4 + 431 + 623 = **1058**

- **Second problem** (operator at col 8, `*`):
  - Col 10: `175`
  - Col 9: `581`
  - Col 8: `32`
  - Problem: 175 × 581 × 32 = **3253600**

- **Third problem** (operator at col 4, `+`):
  - Col 6: `8`
  - Col 5: `248`
  - Col 4: `369`
  - Problem: 8 + 248 + 369 = **625**

- **Leftmost problem** (operator at col 0, `*`):
  - Col 2: `356`
  - Col 1: `24`
  - Col 0: `1`
  - Problem: 356 × 24 × 1 = **8544**

Grand total: 1058 + 3253600 + 625 + 8544 = **3263827** ✓

## Solution Approach

### Part 1: Token-Based Parsing

1. **Split by whitespace**: Parse each line into tokens
2. **Match columns**: The nth token in each row belongs to the nth problem
3. **Calculate**: For each problem, apply the operator to all numbers
4. **Sum results**: Add all problem answers

### Part 2: Character-Position Parsing

1. **Find operators**: Scan right-to-left through the operator line
2. **For each operator**:
   - Collect all digit columns to the right (including operator column)
   - Stop when hitting a space column
   - Read each column top-to-bottom to form multi-digit numbers
3. **Calculate each problem**: Apply operator to the numbers
4. **Sum results**: Add all problem answers

### Key Insights

- **Part 1 vs Part 2**: Completely different parsing methods!
  - Part 1: Token-based (split by whitespace)
  - Part 2: Character-position based (read by column index)
- **Right-to-left reading**: Problems are defined by operators, scan right from each operator
- **Vertical number formation**: Digits in the same column form a single number
- **Space columns as separators**: Empty columns separate different problems

## Results

- **Part 1 Answer**: `6100348226985`
  - Sample test: 4277556 ✓
- **Part 2 Answer**: `12377473011151`
  - Sample test: 3263827 ✓

## Implementation Details

### Classes

- `MathWorksheet`: Manages math problems and calculations
  - `parse(from:)`: Part 1 token-based parsing
  - `parseCephalopod(from:)`: Part 2 character-position parsing
  - `calculateGrandTotal()`: Sum all problem answers

- `MathProblem`: Represents a single math problem
  - `numbers`: List of numbers in the problem
  - `operation`: The operator (`+` or `*`)
  - `solve()`: Calculate the result

### Parsing Strategies

**Part 1 (Token-Based)**:
```swift
// Split each line by whitespace
let numberTokens = numberLines.map { $0.split(separator: " ") }
// Match nth token to nth operator
for (col, op) in operatorTokens.enumerated() {
    for row in numberTokens {
        columnNumbers.append(row[col])
    }
}
```

**Part 2 (Character-Position)**:
```swift
// Scan right-to-left through character positions
var col = maxLength - 1
while col >= 0 {
    if opChar == "+" || opChar == "*" {
        // Scan right from operator to collect number columns
        while scanCol < maxLength {
            // Read digits vertically from this column
        }
    }
}
```

### Files

- `MathWorksheet.swift`: Core parsing and calculation logic
- `InputReader.swift`: File reading utility
- `main.swift`: Program entry point with test cases

## Usage

```bash
swift run
# or
swiftc Sources/*.swift -o solve && ./solve
```

## Time Complexity

- **Parsing**: O(R × C) where R = rows, C = columns
- **Calculation**: O(P × N) where P = problems, N = numbers per problem
- **Overall**: O(R × C)

## Space Complexity

- O(R × C) for grid storage
- O(P × N) for problem storage
