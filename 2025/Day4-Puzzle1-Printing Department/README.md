# Advent of Code 2025 - Day 4: Printing Department

## Problem Summary

The elevators are still offline, so we're taking the stairs to the printing department. The department has paper rolls stored on a grid, and we need to help determine which rolls are accessible by forklift.

### Part 1: Count Accessible Rolls

- **Grid**: Paper rolls (@) and empty spaces (.)
- **Accessibility Rule**: A roll is accessible if it has **fewer than 4 rolls** in the 8 adjacent positions
- **8 Directions**: N, S, E, W, NE, NW, SE, SW
- **Goal**: Count how many rolls are accessible

---

## Examples

### Sample Grid (10x10)

```
@.@.......
..........
@.@.@.@...
.@.@......
@.@.@.@...
..........
@.@.@.@...
.@.@......
..........
.@.@.@.@..
```

**Analysis**:
- Total paper rolls: 22
- Accessible rolls: Depends on adjacent roll counts
- Example: Position (3,1) has 4 adjacent rolls → NOT accessible
- Example: Position (0,0) has 0 adjacent rolls → accessible

---

## Solution Approach

### Algorithm: Grid Traversal with Adjacency Check

```swift
class PrintingDepartment {
    private let grid: [[Character]]

    func isAccessible(row: Int, col: Int) -> Bool {
        // Must be a roll
        guard grid[row][col] == "@" else { return false }

        // Count adjacent rolls
        let adjacentCount = countAdjacentRolls(row: row, col: col)

        // Accessible if fewer than 4 neighbors
        return adjacentCount < 4
    }

    private func countAdjacentRolls(row: Int, col: Int) -> Int {
        let directions = [
            (-1, 0),  // N
            (1, 0),   // S
            (0, -1),  // W
            (0, 1),   // E
            (-1, -1), // NW
            (-1, 1),  // NE
            (1, -1),  // SW
            (1, 1)    // SE
        ]

        var count = 0
        for (dr, dc) in directions {
            let newRow = row + dr
            let newCol = col + dc

            // Check bounds and if position has a roll
            if isValidPosition(newRow, newCol) && grid[newRow][newCol] == "@" {
                count += 1
            }
        }

        return count
    }
}
```

**How it works**:
1. Parse the grid into a 2D array of characters
2. For each position in the grid:
   - Check if it contains a paper roll (@)
   - Count how many of the 8 adjacent positions also contain rolls
   - If count < 4, the roll is accessible
3. Sum up all accessible rolls

**Complexity**: O(n × m) where n and m are grid dimensions
- Each cell checked once: O(n × m)
- Each adjacency check: O(8) = O(1)
- Total: O(n × m)

---

## Results

### Part 1: Count Accessible Rolls

**Sample Input:**
- Grid: 10×10
- Total Rolls: 22
- Got: 20
- Note: Sample test shows 20 accessible rolls with the current logic

**Actual Puzzle Input:**
- Grid: 100×108
- Answer: **861** ✅

---

## Code Structure

```
Day4-Puzzle1-Printing Department/
├── Sources/
│   ├── PrintingDepartment.swift  # Core grid and accessibility logic
│   │   ├── init(gridString:)           # Parse grid
│   │   ├── isAccessible(row:col:)      # Check if roll is accessible
│   │   ├── countAdjacentRolls()        # Count neighbors
│   │   ├── countAccessibleRolls()      # Main solving function
│   │   └── visualizeAccessibleRolls()  # Debug visualization
│   ├── InputReader.swift         # File reading utility
│   └── main.swift                # Entry point
├── Inputs/
│   ├── sample.txt                # Sample test data
│   └── input.txt                 # Actual puzzle input
├── Package.swift
└── .gitignore
```

---

## How to Run

```bash
cd "2025/Day4-Puzzle1-Printing Department"
swift run
```

Or compile directly:
```bash
swiftc Sources/*.swift -o solve
./solve
```

---

## Key Implementation Details

### Grid Parsing

Parse the input string into a 2D array:
```swift
let lines = gridString.split(separator: "\n").map { String($0) }
self.grid = lines.map { Array($0) }
```

### Adjacency Check

The 8 directions are checked systematically:
- Cardinal: N, S, E, W
- Diagonal: NE, NW, SE, SW

Boundary checking prevents index out of bounds:
```swift
guard newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols else {
    continue
}
```

### Accessibility Condition

A roll is accessible when:
```swift
adjacentCount < 4  // Fewer than 4 neighbors
```

This means rolls can have 0, 1, 2, or 3 adjacent rolls to be accessible.

---

## Complexity Analysis

**Time Complexity**: O(n × m)
- n = number of rows
- m = number of columns
- Each cell visited once
- Constant time (O(8)) adjacency check per cell

**Space Complexity**: O(n × m)
- Store the entire grid in memory
- No additional data structures needed

**For the actual input**:
- Grid: 100 rows × 108 columns = 10,800 cells
- Operations: ~86,400 (10,800 × 8)
- Runtime: < 1 millisecond

---

## Learning Points

1. **Grid Traversal**: Systematic scanning of 2D arrays
2. **Adjacency Checking**: 8-directional neighbor analysis
3. **Boundary Conditions**: Handling edge and corner cases
4. **Character Arrays**: Efficient grid representation in Swift
5. **Problem Modeling**: Translating real-world constraints into code

---

## Visualization

The solution includes a visualization method that shows accessible rolls:

```swift
func visualizeAccessibleRolls() -> String {
    var result = ""
    for row in 0..<rows {
        for col in 0..<cols {
            if grid[row][col] == "@" && isAccessible(row: row, col: col) {
                result += "x"  // Mark accessible
            } else {
                result += String(grid[row][col])
            }
        }
        result += "\n"
    }
    return result
}
```

This helps debug by showing which rolls are accessible (marked with 'x').

---

## Algorithm Correctness

The algorithm correctly implements the problem requirements:

1. **Roll Identification**: Only considers positions with '@'
2. **8-Direction Check**: Examines all adjacent positions (including diagonals)
3. **Count Threshold**: Uses strict inequality (< 4) for accessibility
4. **Boundary Safety**: Handles grid edges properly

**Example walkthrough** for position (3,1):
```
Grid around (3,1):
  @ . @     Row 2
  . @ .     Row 3 (position 3,1 is here)
  @ . @     Row 4

Adjacent rolls:
- NW (2,0): @ ✓
- NE (2,2): @ ✓
- SW (4,0): @ ✓
- SE (4,2): @ ✓
Total: 4 → NOT accessible (need < 4)
```

---

Day 4 complete! 🎄
