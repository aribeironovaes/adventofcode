# Day 7: Laboratories

## Problem Description

You find yourself in a teleporter lab with a malfunctioning tachyon manifold. The diagnostic tool shows error code 0H-N0, indicating an issue with one of the tachyon manifolds.

### Part 1: Beam Splitting Analysis

A tachyon beam enters the manifold at location `S` and moves downward. The beam behavior:
- Passes freely through empty space (`.`)
- When encountering a splitter (`^`), the beam stops and creates two new beams:
  - One beam continues from immediately left of the splitter
  - One beam continues from immediately right of the splitter

The goal is to count how many times beams are split in the manifold.

#### Example

```
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
```

In this example:
1. The beam enters at `S` and moves downward
2. It hits the first splitter and splits into 2 beams (left and right)
3. Those beams continue downward and hit more splitters
4. The process continues until all beams exit the manifold
5. Total splits: **21**

## Solution Approach

### Algorithm

1. **Parse the manifold**: Read the grid and locate the starting position `S`
2. **Simulate beam propagation**:
   - Maintain a queue of active beams with their positions
   - For each beam, move it down one row
   - If it hits a splitter (`^`), count the split and create two new beams (left and right)
   - Track processed splitters to avoid double-counting
   - Continue until all beams exit the manifold
3. **Count splits**: Keep a count of how many times beams are split

### Key Insights

- Each splitter can only be counted once, even if multiple beams hit it
- Beams move strictly downward until hitting a splitter
- When a splitter is hit, the original beam stops and two new beams start from adjacent columns
- Need to track which splitters have been processed to avoid counting the same split multiple times

### Data Structures

- **Beam**: Stores position (row, col) of a beam
- **Set**: Track processed splitter positions to avoid double-counting
- **Queue**: Manage active beams during simulation

## Results

- **Part 1 Answer**: `1711`
  - Sample test: 21 ✓

## Implementation Details

### Classes

- `TachyonManifold`: Simulates tachyon beam behavior in the manifold
  - `init(from:)`: Parse the manifold grid and find starting position
  - `countSplits()`: Simulate beam propagation and count splits

### Files

- `TachyonManifold.swift`: Core beam simulation logic
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
- **Simulation**: O(S × B) where S = number of splitters, B = maximum beams
- **Overall**: O(R × C) for typical inputs where beam count is bounded

## Space Complexity

- O(S) for tracking processed splitters
- O(B) for active beam queue
- O(R × C) for grid storage
