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
- **Part 2 Answer**: `4583207265`
  - Sample test: 24 ✓

## Part 2: Rectangle with Red/Green Tiles Only

### Problem

Now rectangles can only contain red or green tiles. Green tiles are:
1. **Boundary**: Tiles connecting consecutive red tiles in the input order
2. **Interior**: All tiles inside the closed polygon formed by the red tiles

The input order matters! Red tiles form a polygon when connected in sequence, and this polygon wraps (first connects to last).

#### Example

With the same 8 red tiles forming a polygon:
- Green boundary tiles connect each consecutive pair
- Green interior tiles fill the polygon
- Rectangle must have red corners
- Rectangle can only contain red/green tiles (no other tiles)

Maximum area: **24** (e.g., between tiles (9,5) and (2,3))

### Algorithm

1. **Polygon representation**: Red tiles in input order form polygon vertices
2. **For each pair of red tiles**:
   - Check if rectangle's four corners are all inside/on the polygon
   - If yes, entire rectangle is valid (polygon property)
   - Calculate area if valid
3. **Return maximum area**

### Optimization

Instead of materializing all green tiles (could be millions with large coordinates):
- **Use ray casting** to check if points are inside polygon
- **Check boundary** explicitly for edge cases
- Only validate the 4 rectangle corners, not every interior tile

This reduces complexity from O(N² × Area) to O(N² × Polygon_Vertices).

### Point-in-Polygon Test

**Ray Casting Algorithm**:
Cast a ray from the point to infinity and count edge crossings:
- Odd crossings = inside
- Even crossings = outside

```swift
func isInsidePolygon(_ point: Point) -> Bool {
    var inside = false
    for i in 0..<n {
        let vi = vertices[i]
        let vj = vertices[j]
        if ((vi.y > point.y) != (vj.y > point.y)) &&
           (point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x) {
            inside.toggle()
        }
    }
    return inside
}
```

**Boundary Check**:
For each edge of polygon, check if point lies on the line segment.

## Implementation Details

### Data Structures

- `Point`: 2D coordinate (x, y)
- `TileRectangleFinder`: Main solver class
  - Stores list of red tile positions
  - Calculates maximum rectangle area

### Classes

- `TileRectangleFinder`: Finds largest rectangle
  - `init(from:)`: Parse tile coordinates
  - `findLargestRectangleArea()`: Try all pairs, return max area (Part 1)
  - `findLargestRectangleWithGreen()`: Try pairs with polygon constraint (Part 2)
  - `isInsidePolygon(_:)`: Ray casting point-in-polygon test
  - `isOnBoundary(_:)`: Check if point is on polygon edge

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
- **Part 1 - Pair enumeration**: O(N²) to check all pairs
- **Part 2 - Pair enumeration**: O(N²) pairs
- **Part 2 - Polygon test per pair**: O(N) for ray casting
- **Part 2 Overall**: O(N³)

For N ≈ 200-300 tiles:
- Part 1: ~40,000-90,000 operations (instant)
- Part 2: ~8-27 million operations (still fast, sub-second)

### Space Complexity

- **Tile storage**: O(N) for storing coordinates
- **Overall**: O(N)

No need to materialize green tiles (which could be O(Area) with large coordinates).

## Computational Geometry Concepts

### Point-in-Polygon

Classic problem with multiple solutions:
1. **Ray Casting** (used here): O(N) per query
2. **Winding Number**: O(N) per query
3. **Preprocessing**: Can reduce to O(log N) with complex structures

### Rectangle Validation

Key insight: If all 4 corners of an axis-aligned rectangle are inside a polygon, the entire rectangle is inside (assuming convex or reasonable polygon shape).

This works because:
- Rectangle edges are straight lines
- If corners are inside, no edge can escape and re-enter
- Avoids checking potentially millions of interior tiles

### Edge Cases Handled

- **Points on boundary**: Explicitly checked with `isOnBoundary`
- **Red tile corners**: Always valid (part of polygon vertices)
- **Degenerate rectangles**: Width or height = 1 (still valid)

## Potential Extensions

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
