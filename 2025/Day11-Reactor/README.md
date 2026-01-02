# Day 11: Reactor

## Problem Description

The reactor control system is modeled as a directed graph of interconnected devices. Each device can output signals to one or more other devices.

### Part 1: Path Enumeration

**Goal**: Count all distinct paths from node `you` to node `out` in the device graph.

#### Input Format
```
device: output1 output2 output3 ...
```

Each line represents a device and its connected outputs.

#### Example
```
you: drs plk eph
drs: out
plk: xyz
xyz: out
eph: out
```

This graph has 3 paths from `you` to `out`:
1. `you → drs → out`
2. `you → plk → xyz → out`
3. `you → eph → out`

## Solution Approach - Part 1

### Algorithm: Depth-First Search with Backtracking

This is a classic **graph path enumeration** problem solved using DFS.

```swift
func countPaths(from: String, to: String, visited: Set<String>) -> Int {
    // Base case: reached destination
    if from == to {
        return 1
    }

    // No neighbors → dead end
    guard let neighbors = graph[from] else {
        return 0
    }

    // Explore all unvisited neighbors
    var totalPaths = 0
    var currentVisited = visited
    currentVisited.insert(from)

    for neighbor in neighbors {
        if !currentVisited.contains(neighbor) {
            totalPaths += countPaths(from: neighbor, to: to, visited: currentVisited)
        }
    }

    return totalPaths
}
```

### Key Insights

1. **Cycle Detection**: Track visited nodes per path to avoid infinite loops
2. **Backtracking**: Remove node from visited set when backtracking
3. **Directed Graph**: Follow edges in one direction only
4. **Exhaustive Search**: Enumerate all possible paths

### Data Structures

- **Graph Representation**: `[String: [String]]` - adjacency list mapping device → outputs
- **Visited Set**: `Set<String>` - track visited nodes in current path
- **Path Count**: `Int` - accumulate total number of valid paths

## Results - Part 1

- **Answer**: `674` paths from `you` to `out`
- **Sample Test**: 5 paths ✓

## Part 2: Constrained Path Enumeration

### Problem

Count paths from `svr` to `out` that visit **both** `dac` AND `fft` (in any order).

This is a **constrained path enumeration** problem - we need to track which required nodes have been visited.

### Example

```
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
```

Valid paths must visit both `dac` and `fft` before reaching `out`:
1. `svr → aaa → fft → ccc → eee → dac → fff → ggg → out`
2. `svr → aaa → fft → ccc → eee → dac → fff → hhh → out`

**Answer**: 2 paths

### Initial Approach - Exponential Time Complexity

```swift
func countPathsWithRequired(
    from: String,
    to: String,
    visited: Set<String>,
    requiredVisited: Set<String>,
    requiredNodes: Set<String>
) -> Int {
    // Track required nodes
    var newRequiredVisited = requiredVisited
    if requiredNodes.contains(from) {
        newRequiredVisited.insert(from)
    }

    // Base case: only count if all required nodes visited
    if from == to {
        return newRequiredVisited == requiredNodes ? 1 : 0
    }

    // DFS exploration...
}
```

**Problem**: This approach has **exponential time complexity** and ran for 20+ minutes without completing on the actual input.

### Optimized Approach - Memoization

The key insight: when we reach a node with a specific set of required nodes already visited, the number of valid paths to the destination is the same **regardless of how we got there**.

This is perfect for **dynamic programming with memoization**.

#### Memoization Key

```swift
struct MemoKey: Hashable {
    let node: String
    let requiredVisited: Set<String>
}
```

The cache key is `(current node, set of required nodes visited so far)`.

#### Memoized Algorithm

```swift
func countPathsWithMemo(
    from: String,
    to: String,
    visited: Set<String>,
    requiredVisited: Set<String>,
    requiredNodes: Set<String>,
    memo: inout [MemoKey: Int]
) -> Int {
    // Update required nodes tracking
    var newRequiredVisited = requiredVisited
    if requiredNodes.contains(from) {
        newRequiredVisited.insert(from)
    }

    // Base case
    if from == to {
        return newRequiredVisited == requiredNodes ? 1 : 0
    }

    // Check cache before computing
    let key = MemoKey(node: from, requiredVisited: newRequiredVisited)
    if let cached = memo[key] {
        return cached
    }

    // Compute result
    guard let neighbors = graph[from] else {
        memo[key] = 0
        return 0
    }

    var totalPaths = 0
    var currentVisited = visited
    currentVisited.insert(from)

    for neighbor in neighbors {
        if !currentVisited.contains(neighbor) {
            totalPaths += countPathsWithMemo(
                from: neighbor,
                to: to,
                visited: currentVisited,
                requiredVisited: newRequiredVisited,
                requiredNodes: requiredNodes,
                memo: &memo
            )
        }
    }

    // Cache result before returning
    memo[key] = totalPaths
    return totalPaths
}
```

### Why Memoization Works

Consider reaching node `X` with required nodes `{dac}` visited:
- Path A: `svr → ... → fft → ... → X`
- Path B: `svr → ... → fft → ... → (different route) → X`

Both paths arrive at `X` having visited `{dac}`. The number of ways to reach `out` from this state is **identical** for both paths. Without memoization, we'd recompute this exponentially many times.

### Performance Comparison

| Approach | Time | Result |
|----------|------|--------|
| No memoization | 20+ minutes (timeout) | N/A |
| With memoization | < 1 second | 438,314,708,837,664 ✓ |

The memoization reduced the time complexity from exponential to polynomial.

## Results - Part 2

- **Answer**: `438314708837664` paths from `svr` to `out` visiting both `dac` and `fft`
- **Sample Test**: 2 paths ✓

## Complexity Analysis

### Part 1 - Without Memoization

- **Time Complexity**: O(V + E) × P where:
  - V = number of vertices
  - E = number of edges
  - P = number of paths (can be exponential)
- **Space Complexity**: O(V) for visited set and recursion stack

### Part 2 - With Memoization

- **Time Complexity**: O(V × 2^R × E) where:
  - V = number of vertices
  - R = number of required nodes (2 in this case)
  - E = average edges per vertex
  - Each unique (node, requiredVisited) state is computed only once
- **Space Complexity**: O(V × 2^R) for memoization cache

For R = 2 required nodes, there are only 4 possible states for `requiredVisited`:
- `{}` - neither visited
- `{dac}` - only dac visited
- `{fft}` - only fft visited
- `{dac, fft}` - both visited

This bounded state space makes memoization extremely effective.

## Implementation Files

- `solve.swift`: Part 1 solution (674 paths)
- `test.swift`: Part 1 test with sample input
- `solve_both.swift`: Part 2 without memoization (too slow)
- `solve_memo.swift`: Part 2 with memoization (both parts) ✓
- `test_part2.swift`: Part 2 test without memoization
- `test_memo.swift`: Part 2 test with memoization
- `test_part2.txt`: Sample input for Part 2

## Usage

### Part 1
```bash
chmod +x solve.swift
./solve.swift
# or
swift solve.swift
```

### Part 2 (with memoization)
```bash
chmod +x solve_memo.swift
./solve_memo.swift
# or
swift solve_memo.swift
```

## Sample Output

### Part 1
```
Paths from 'you' to 'out': 674
```

### Part 2
```
Part 1 - Paths from 'you' to 'out': 674
Part 2 - Paths from 'svr' to 'out' visiting 'dac' and 'fft': 438314708837664
```

## Key Takeaways

1. **Path Enumeration**: Standard DFS with backtracking for counting all paths
2. **Cycle Detection**: Essential to avoid infinite loops in directed graphs
3. **Memoization**: Critical optimization when subproblems have overlapping structure
4. **State Space**: With only 2 required nodes, the state space is small enough for efficient caching
5. **Exponential → Polynomial**: Proper memoization transformed an intractable problem into one solvable in under a second

## Learning Points

- **Dynamic Programming**: Recognize when subproblems overlap and can be cached
- **State Design**: Choosing the right cache key is crucial (node + requiredVisited)
- **Graph Traversal**: DFS is natural for path enumeration problems
- **Performance**: Always analyze time complexity - exponential algorithms need optimization
- **Memoization vs Tabulation**: Top-down memoization is cleaner for path problems than bottom-up tabulation

## Extensions

Potential variations:
- **Weighted Paths**: Find shortest/longest path instead of counting all paths
- **More Required Nodes**: Problem complexity grows as O(V × 2^R) with R required nodes
- **Path Reconstruction**: Store actual paths, not just counts
- **Forbidden Nodes**: Count paths that avoid certain nodes
- **Multiple Destinations**: Count paths to any of several target nodes

## Mathematical Perspective

This problem is related to:
- **Path Enumeration**: Counting simple paths in directed graphs
- **Hamiltonian Path Variants**: Finding paths that visit specific vertices
- **Dynamic Programming on DAGs**: Although this graph may have cycles, memoization handles them via the visited set
- **Subset Sum of States**: The requiredVisited set forms a power set with 2^R elements

The memoization essentially builds a **dynamic programming table** indexed by (node, subset) pairs, similar to traveling salesman problem (TSP) approaches but simpler because we only need to visit 2 specific nodes, not all nodes.
