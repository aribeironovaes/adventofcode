# Day 5: Cafeteria

## Problem Description

You arrive at the North Pole cafeteria where ingredients are tracked by ID numbers. Each ingredient has a freshness range, and you need to determine which ingredient IDs are considered "fresh."

### Part 1: Count Fresh Ingredients

Given:
- A list of ID ranges (start-end) that define fresh ingredients
- A list of ingredient IDs to check

Goal: Count how many of the given ingredient IDs fall within any of the fresh ranges.

#### Example

```
Ranges:
1-5
8-12

IDs to check:
3  -> Fresh (in range 1-5)
7  -> Not fresh
10 -> Fresh (in range 8-12)
15 -> Not fresh

Result: 2 fresh ingredients
```

### Part 2: Total Fresh IDs Across All Ranges

Instead of checking a specific list of IDs, count the total number of unique IDs that are fresh across all ranges.

The challenge: ranges can overlap or be adjacent. Need to merge overlapping ranges to avoid double-counting.

#### Example

```
Ranges:
1-5   (5 IDs: 1,2,3,4,5)
8-12  (5 IDs: 8,9,10,11,12)

Total: 10 unique fresh IDs
```

With overlapping ranges:
```
Ranges:
1-5
3-8   (overlaps with 1-5)

After merging: 1-8 (8 unique IDs)
```

## Solution Approach

### Part 1: Range Checking

1. **Parse input**: Extract ranges and IDs to check
2. **Check each ID**: For each ID, check if it falls within any range
3. **Count matches**: Count how many IDs are fresh

Time Complexity: O(N × R) where N = IDs to check, R = number of ranges

### Part 2: Range Merging

1. **Sort ranges**: Sort all ranges by start position
2. **Merge overlapping ranges**:
   - Start with the first range
   - For each subsequent range:
     - If it overlaps or is adjacent to current range: extend current range
     - Otherwise: save current range, start new range
3. **Count total IDs**: Sum up the size of all merged ranges

Time Complexity: O(R log R) for sorting + O(R) for merging = O(R log R)

### Key Insights

- **Part 1**: Simple membership testing - does ID fall in any range?
- **Part 2**: Range merging problem - need to handle overlaps and adjacency
- **Adjacent ranges**: Ranges like [1-5] and [6-10] should be merged into [1-10]
- **Overlapping ranges**: [1-5] and [3-8] merge into [1-8]

### Algorithm for Range Merging

```swift
1. Sort ranges by start position
2. Initialize: currentStart = first range start, currentEnd = first range end
3. For each remaining range:
   if range.start <= currentEnd + 1:
     // Overlapping or adjacent - extend current range
     currentEnd = max(currentEnd, range.end)
   else:
     // Gap found - count current range and start new one
     totalCount += (currentEnd - currentStart + 1)
     currentStart = range.start
     currentEnd = range.end
4. Add final range to total count
```

## Results

- **Part 1 Answer**: `761`
  - Sample test: 3 ✓
- **Part 2 Answer**: `345755049374932`
  - Sample test: 14 ✓

## Implementation Details

### Classes

- `IngredientDatabase`: Manages ingredient ranges and ID checking
  - `parse(from:)`: Parse input file into ranges and IDs
  - `countFreshIngredients()`: Count how many given IDs are fresh (Part 1)
  - `countTotalFreshIDs()`: Count total unique IDs across all ranges (Part 2)

### Data Structures

- `Range`: Stores start and end of ID range
- Array of ranges for the database
- Set for efficient ID lookup (Part 1)

### Files

- `IngredientDatabase.swift`: Core range checking and merging logic
- `InputReader.swift`: File reading utility
- `main.swift`: Program entry point with test cases

## Usage

```bash
swift run
# or
swiftc Sources/*.swift -o solve && ./solve
```

## Time Complexity

- **Part 1**: O(N × R) where N = IDs to check, R = number of ranges
- **Part 2**: O(R log R) for sorting and merging ranges

## Space Complexity

- O(R) for storing ranges
- O(N) for storing IDs to check (Part 1)
