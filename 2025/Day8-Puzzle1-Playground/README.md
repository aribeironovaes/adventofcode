# Day 8: Playground

## Problem Description

You arrive at a vast underground playground where Elves are setting up Christmas decorations using electrical junction boxes suspended in 3D space. They need to connect junction boxes with strings of lights to allow electricity to flow between them.

### Part 1: Shortest Connections

The Elves want to minimize the amount of string lights used by connecting pairs of junction boxes that are closest together. The task is to:
1. Calculate distances between all pairs of junction boxes
2. Connect the N shortest pairs (attempting to connect, some may already be connected)
3. Track which boxes end up in the same circuit (connected component)
4. Find the product of the three largest circuit sizes

#### Example

With 20 junction boxes, after attempting to connect the 10 shortest pairs:
- Some connections succeed, others are skipped (if already connected)
- Results in 11 separate circuits:
  - 1 circuit with 5 boxes
  - 1 circuit with 4 boxes
  - 2 circuits with 2 boxes each
  - 7 circuits with 1 box each
- Product of three largest: 5 × 4 × 2 = **40**

#### Key Detail

"Making the ten shortest connections" means **attempting** the 10 shortest edge pairs, not necessarily making 10 successful connections. If two boxes are already in the same circuit, that connection attempt does nothing.

## Solution Approach

This is a graph connectivity problem that uses concepts from Kruskal's Minimum Spanning Tree algorithm.

### Algorithm

1. **Parse junction box positions** in 3D space (X, Y, Z coordinates)
2. **Calculate all pairwise distances**:
   - For N junction boxes, there are N×(N-1)/2 pairs
   - Use squared Euclidean distance (avoids expensive sqrt, preserves ordering)
   - Distance² = (x₁-x₂)² + (y₁-y₂)² + (z₁-z₂)²
3. **Sort all edges** by distance (ascending)
4. **Union-Find data structure**:
   - Track connected components (circuits)
   - Start with each box in its own component
   - Union operation merges components when connecting boxes
5. **Process shortest N edges**:
   - Attempt to connect the N shortest pairs
   - Use Union-Find to track which boxes are connected
   - Some edges may be redundant (boxes already connected)
6. **Find component sizes**:
   - Count the size of each connected component
   - Sort sizes in descending order
   - Return product of three largest sizes

### Union-Find (Disjoint Set Union)

A data structure that efficiently tracks partitions of elements into disjoint sets:

- **Find**: Determine which set an element belongs to (with path compression)
- **Union**: Merge two sets (with union by rank)
- **Component Sizes**: Track size of each set during unions

Operations are nearly O(1) with path compression and union by rank (amortized O(α(N)) where α is inverse Ackermann function).

### Key Insights

- **Distance calculation**: Use squared distance to avoid floating point and sqrt
- **Edge sorting**: O(E log E) where E = N²/2 edges
- **Union-Find**: Nearly constant time operations for union and find
- **Redundant edges**: Some of the N shortest edges may connect already-connected components
- **Component counting**: After all unions, count distinct root nodes

## Results

- **Part 1 Answer**: `105952`
  - Sample test: 40 ✓

## Implementation Details

### Data Structures

- `Point3D`: 3D coordinate (x, y, z)
  - `squaredDistanceTo()`: Calculate squared Euclidean distance
- `Edge`: Connection between two points with distance
  - Comparable by squared distance
- `UnionFind`: Disjoint set union data structure
  - Path compression for efficient find
  - Union by rank for balanced trees
  - Component size tracking
- `JunctionBoxNetwork`: Main solver class
  - Parse points from input
  - Generate and sort all edges
  - Apply union-find with shortest edges
  - Calculate result

### Classes

- `JunctionBoxNetwork`: Manages junction box connections
  - `init(from:)`: Parse 3D coordinates
  - `connectShortestEdges(_:)`: Process N shortest edges and return product

- `UnionFind`: Tracks connected components
  - `find(_:)`: Find root with path compression
  - `union(_:_:)`: Merge components with union by rank
  - `getAllComponentSizes()`: Get sizes of all components

### Files

- `JunctionBoxNetwork.swift`: Main solver logic
- `UnionFind.swift`: Union-Find data structure
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

- **Parsing**: O(N) where N = number of junction boxes
- **Edge generation**: O(N²) to create all pairs
- **Sorting edges**: O(E log E) where E = N²/2 ≈ O(N² log N)
- **Union-Find operations**: O(N × α(N)) ≈ O(N) for N unions/finds
- **Overall**: O(N² log N) dominated by edge sorting

### Space Complexity

- **Points storage**: O(N)
- **Edges storage**: O(N²) for all pairwise edges
- **Union-Find**: O(N) for parent, rank, and size arrays
- **Overall**: O(N²) for edge storage

### Optimizations

- **Squared distance**: Avoid sqrt computation
- **Path compression**: Flatten union-find trees
- **Union by rank**: Keep trees balanced
- **Early termination**: Stop after processing N edges (don't need full MST)

## Mathematical Foundation

This problem is related to:
- **Minimum Spanning Tree (MST)**: Similar to Kruskal's algorithm
- **Connected Components**: Graph connectivity analysis
- **Euclidean Distance**: 3D geometry
- **Union-Find**: Efficient set operations

The key difference from standard MST is that we only process the first N edges and then analyze the resulting forest (multiple components) rather than creating a single connected tree.
