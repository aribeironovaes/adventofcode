# Day 9: Movie Theater

## Problem Description

You arrive at the North Pole movie theater which has a large tile floor with red tiles scattered across it. The Elves want to find the largest rectangle that uses two red tiles as opposite corners.

### Part 1: Largest Rectangle

Given a list of red tile coordinates, find the largest rectangle area where two red tiles serve as opposite corners.

#### Example

With 8 red tiles:
```
7,1   11,1   11,7   9,7
9,5   2,5    2,3    7,3
```

Visualized on a grid (# = red tile):
```
..............
.......#...#..
..............
..#....#......
..............
..#......#....
..............
.........#.#..
..............
```

Possible rectangles:
- **(2,5) to (9,7)**: 8 × 3 = 24 area
- **(7,1) to (11,7)**: 5 × 7 = 35 area
- **(7,3) to (2,3)**: 6 × 1 = 6 area
- **(2,5) to (11,1)**: 10 × 5 = **50 area** ← Maximum!

The largest rectangle has area **50**.

#### Key Insight

When calculating rectangle area with corners at (x₁, y₁) and (x₂, y₂):
- Width = |x₂ - x₁| + 1 (inclusive of both corners)
- Height = |y₂ - y₁| + 1 (inclusive of both corners)
- Area = Width × Height

The "+1" accounts for the tiles at both corners being included in the rectangle.

## Solution Approach

### Algorithm

This is a straightforward brute-force approach:

1. **Parse red tile coordinates** from input
2. **Try all pairs of tiles** as potential opposite corners
3. **Calculate rectangle area** for each pair:
   - Width = |x₂ - x₁| + 1
   - Height = |y₂ - y₁| + 1
   - Area = Width × Height
4. **Track maximum area** found
5. **Return the maximum**

### Why This Works

- Any two tiles can form opposite corners of a rectangle
- We want to maximize area = width × height
- For N tiles, there are C(N,2) = N×(N-1)/2 pairs to check
- No optimization needed - the problem is asking for ALL possible pairs

### Example Walkthrough

For tiles (2,5) and (11,1):
- Width = |11 - 2| + 1 = 9 + 1 = 10
- Height = |1 - 5| + 1 = 4 + 1 = 5
- Area = 10 × 5 = 50 ✓

## Results

- **Part 1 Answer**: `4790063600`
  - Sample test: 50 ✓

## Implementation Details

### Data Structures

- `Point`: 2D coordinate (x, y)
- `TileRectangleFinder`: Main solver class
  - Stores list of red tile positions
  - Calculates maximum rectangle area

### Classes

- `TileRectangleFinder`: Finds largest rectangle
  - `init(from:)`: Parse tile coordinates
  - `findLargestRectangleArea()`: Try all pairs, return max area

### Files

- `TileRectangleFinder.swift`: Core rectangle calculation logic
- `InputReader.swift`: File reading utility
- `main.swift`: Program entry point

## Usage

```bash
swift run
# or
swiftc Sources/*.swift -o solve && ./solve
```

## Complexity Analysis

### Time Complexity

- **Parsing**: O(N) where N = number of red tiles
- **Pair enumeration**: O(N²) to check all pairs
- **Area calculation**: O(1) per pair
- **Overall**: O(N²)

For typical inputs with hundreds of tiles, this completes instantly.

### Space Complexity

- **Tile storage**: O(N) for storing coordinates
- **Overall**: O(N)

### Why No Optimization Needed

With N ≈ 200-300 tiles (typical Advent of Code size):
- N² ≈ 40,000-90,000 operations
- Each operation is simple arithmetic (subtraction, absolute value, addition, multiplication)
- Modern computers handle millions of such operations per second
- No need for spatial indexing, sweep line algorithms, or other optimizations

## Mathematical Properties

### Rectangle Area Formula

For corners at (x₁, y₁) and (x₂, y₂):

```
Area = (|x₂ - x₁| + 1) × (|y₂ - y₁| + 1)
```

The "+1" comes from inclusive counting:
- Distance 0 (same coordinate) = 1 tile
- Distance 1 = 2 tiles
- Distance n = n+1 tiles

### Maximum Area Considerations

The maximum possible area is bounded by:
- Max X range: (max_x - min_x + 1)
- Max Y range: (max_y - min_y + 1)
- But the actual maximum depends on which tiles happen to be red

There's no closed-form solution - we must check all pairs.

## Edge Cases

- **Collinear tiles** (same X or Y): Area = width or height (the other dimension is 1)
- **Identical tiles**: Not possible (each tile appears once)
- **Single tile**: No pairs, no rectangles
- **Two tiles**: One pair, one area

## Potential Extensions

If we needed to optimize for millions of tiles:
1. **Sort tiles**: By X then Y coordinates
2. **Pruning**: Skip pairs that can't beat current max
3. **Divide & conquer**: Partition space and find local maxima
4. **Spatial indexing**: Use quadtrees or R-trees

But for Advent of Code scale, brute force is perfect!
