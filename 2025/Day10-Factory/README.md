# Day 10: Factory

## Problem Description

The factory machines need to be initialized by configuring their indicator lights to match specific patterns. Each machine has:
- **Indicator lights**: Initially all off, need to match a target pattern (`.` = off, `#` = on)
- **Buttons**: Each button toggles specific lights when pressed
- **Goal**: Find the minimum number of button presses to configure all machines

### Example

```
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
```

- `[.##.]` = Target: lights 0,1,2,3 should be OFF,ON,ON,OFF
- `(3)` = Button that toggles light 3
- `(1,3)` = Button that toggles lights 1 and 3
- `{...}` = Joltage requirements (ignored)

## Solution Approach

This is a classic **linear algebra problem over GF(2)** (the binary field with elements {0, 1}).

### Key Insights

1. **Toggle Operations**: Pressing a button toggles lights (XOR operation)
2. **Idempotent**: Pressing a button twice returns to original state
3. **Binary Decision**: Only need to decide: press each button 0 or 1 times
4. **Commutativity**: Order doesn't matter (XOR is commutative)

### Mathematical Model

For a machine with `n` lights and `m` buttons:

- Let `x_i ∈ {0,1}` = whether to press button `i`
- Let `A` = `m × n` matrix where `A[i][j] = 1` if button `i` toggles light `j`
- Let `b` = target state vector (0 = off, 1 = on)

We need to solve: **Ax = b (mod 2)**

And minimize: **sum(x_i)**

### Algorithm

**Brute Force Approach** (for small systems):
```
For each combination of button presses (2^m possibilities):
  1. Simulate pressing selected buttons
  2. Check if result matches target
  3. Track minimum number of presses
```

This works because:
- Most machines have ≤ 12 buttons (2^12 = 4,096 combinations)
- XOR operations are fast
- Exhaustive search guarantees finding the minimum

**Alternative: Gaussian Elimination** (not implemented):
- Convert to reduced row echelon form over GF(2)
- Extract minimal solution from free variables
- More efficient for large systems but more complex

## Implementation Details

### Data Structures

- **Target**: Array of `Int` (0 or 1) representing desired light states
- **Buttons**: Array of arrays, where each inner array contains light indices

### Functions

1. **`parseMachine(_ line: String)`**
   - Extracts target pattern from `[...]`
   - Extracts button configurations from `(...)`
   - Returns `(target, buttons)` tuple

2. **`tryAllCombinations(buttons:target:)`**
   - Tries all 2^m combinations using bitmask
   - For each combination:
     - Simulates button presses with XOR
     - Checks if result matches target
     - Tracks minimum presses
   - Returns minimum or nil if no solution

### Example Walkthrough

For machine: `[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1)`

**Target**: `[0,1,1,0]` (lights 1 and 2 should be ON)

**Buttons**:
- Button 0: toggles light 3
- Button 1: toggles lights 1,3
- Button 2: toggles light 2
- Button 3: toggles lights 2,3
- Button 4: toggles lights 0,2
- Button 5: toggles lights 0,1

**Solution**: Press buttons 4 and 5 (2 presses)
- Initial: `[0,0,0,0]`
- Press button 4 (0,2): `[1,0,1,0]`
- Press button 5 (0,1): `[0,1,1,0]` ✓

## Results - Part 1

- **Total Machines**: 170
- **Total Button Presses**: 457

---

# Part 2: Joltage Requirements

## Problem Description

Part 2 introduces joltage counters that must reach specific target values:
- Each button press increments certain joltage counters
- Buttons can be pressed **multiple times** (not just 0 or 1)
- Goal: Find minimum button presses to reach all joltage targets

### Example

```
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
```

Now the `{3,5,4,7}` matters:
- Counter 0 must reach value 3
- Counter 1 must reach value 5
- Counter 2 must reach value 4
- Counter 3 must reach value 7

Each button press increments the counters corresponding to the lights it affects.

## Solution Approach - Integer Linear Programming

This is an **Integer Linear Programming (ILP)** problem.

### Mathematical Model

For a machine with `c` counters and `m` buttons:

- Let `x_i ∈ ℤ⁺` = number of times to press button `i`
- Let `A` = `c × m` matrix where `A[j][i] = 1` if button `i` increments counter `j`
- Let `b` = target joltage vector

We need to solve:
```
Minimize:  sum(x_i)
Subject to:  Ax = b
             x_i >= 0
             x_i is integer
```

### Key Differences from Part 1

| Aspect | Part 1 | Part 2 |
|--------|--------|--------|
| Field | GF(2) (binary) | ℤ⁺ (non-negative integers) |
| Button presses | 0 or 1 | 0, 1, 2, 3, ... |
| Operation | XOR (toggle) | Addition (increment) |
| Approach | Brute force 2^m | Integer Linear Programming |
| Complexity | O(2^m × n) | NP-hard (requires ILP solver) |

### Why Not Brute Force?

With buttons pressable multiple times:
- Search space becomes infinite
- Can't enumerate all combinations
- Need sophisticated optimization techniques

### Why Not Gaussian Elimination?

Gaussian elimination (used for linear systems) has limitations:
- Finds **any** solution, not necessarily the minimal one
- Doesn't handle integer constraints
- Doesn't optimize the objective function
- Fails on under-determined systems

## Implementation - PuLP with CBC Solver

### Algorithm

Uses the **PuLP** library with **CBC (Coin-or Branch and Cut)** solver:

```python
import pulp as pl

def solve_ilp(buttons, joltage):
    num_buttons = len(buttons)
    num_counters = len(joltage)

    # Create button matrix: bm[i][j] = 1 if button i affects counter j
    bm = button_matrix(buttons, num_counters)

    # Create ILP problem
    prob = pl.LpProblem("MinimizeButtonPresses", pl.LpMinimize)

    # Create integer variables for button presses
    b = pl.LpVariable.dicts("b", range(num_buttons), lowBound=0, cat="Integer")

    # Objective: minimize total button presses
    prob += pl.lpSum(b[i] for i in range(num_buttons))

    # Constraints: each counter must reach its target
    for j in range(num_counters):
        prob += pl.lpSum(bm[i][j] * b[i] for i in range(num_buttons)) == joltage[j]

    # Solve with CBC solver
    prob.solve(pl.PULP_CBC_CMD(msg=False))

    # Extract solution
    return sum(int(b[i].varValue) for i in range(num_buttons))
```

### How CBC Solver Works

1. **Relaxation**: Solve as continuous LP (allows fractional values)
2. **Branching**: Pick fractional variable, create two subproblems (≤floor, ≥ceil)
3. **Cutting Planes**: Add constraints that eliminate fractional solutions
4. **Pruning**: Discard branches that can't improve best solution
5. **Iteration**: Repeat until all variables are integers

This is exponentially more sophisticated than greedy heuristics or Gaussian elimination.

## Results - Part 2

- **Total Machines**: 170
- **Machines Solved**: 170/170 (100%)
- **Total Button Presses**: 17,576

### Comparison of Approaches

| Approach | Machines Solved | Total Presses | Status |
|----------|----------------|---------------|--------|
| Greedy Heuristic | 1/170 | N/A | Failed |
| Gauss-Jordan | 104/170 | 10,325 | Incomplete |
| Gauss-Jordan + Greedy | 117/170 | 11,639 | Incorrect |
| **PuLP ILP (CBC)** | **170/170** | **17,576** | **Correct** ✓ |

### Example Machine Verification

**Machine 1**: 55 presses (verified manually and by solver)

## Complexity Analysis

### Time Complexity

- **Per Machine**: O(2^m × n) where m = buttons, n = lights
- **Typical**: m ≤ 12, so 2^12 = 4,096 iterations max
- **Each iteration**: O(n) for XOR operations
- **Overall**: Fast for typical inputs

### Space Complexity

- **O(m × L)** where L = average number of lights per button
- Minimal memory usage

## Usage

### Part 1
```bash
chmod +x solve.swift
./solve.swift
```

Or:
```bash
swift solve.swift
```

### Part 2
```bash
python3 solve_p2_pulp.py
```

**Requirements**: PuLP library
```bash
pip3 install pulp
```

## Alternative Approaches

### Part 1: Gaussian Elimination over GF(2)

For larger systems, use GF(2) Gaussian elimination:

1. Create augmented matrix `[A | b]`
2. Row reduce to RREF using XOR operations
3. Identify free variables (buttons we can choose)
4. Set free variables to minimize total presses
5. Back-substitute to find solution

**Advantages**:
- O(m²n) time complexity
- Guaranteed to find solution if one exists
- Identifies if system is unsolvable

**Disadvantages**:
- More complex implementation
- Requires careful handling of free variables
- Not necessary for small systems

### Part 2: Why Other Approaches Failed

**1. Greedy Heuristic**:
- Picks locally optimal choices (press button that helps most)
- Gets stuck in local optima
- Only solved 1/170 machines

**2. Gaussian Elimination**:
- Finds **a** solution, not the **minimal** solution
- No optimization of objective function
- Solved 104/170 (under-determined systems failed)

**3. Gaussian + Greedy Fallback**:
- Combines both approaches
- Better but still not optimal
- Solved 117/170, gave answer 11,639 (incorrect)

**4. Brute Force with Bounds**:
- Could enumerate up to reasonable limits
- Very slow for machines with many buttons
- Timeouts on larger instances

**5. Branch and Bound** (similar to CBC):
- Could be implemented manually
- Very complex to code correctly
- CBC solver already does this optimally

## Edge Cases Handled

### Part 1
1. **No Solution**: Returns nil if target is unreachable
2. **Empty Buttons**: Handles machines with no buttons
3. **Lights Already Correct**: Returns 0 presses if initial state matches target
4. **Multiple Solutions**: Finds the one with minimum presses

### Part 2
1. **Infeasible Systems**: Returns None if constraints cannot be satisfied
2. **Under-determined Systems**: CBC finds minimal solution among infinite possibilities
3. **Over-determined Systems**: Reports if system is inconsistent
4. **Multiple Optimal Solutions**: Returns any one of them (all have same total presses)

## Binary Field (GF(2)) Concepts

### What is GF(2)?

The **Galois Field of order 2** has two elements: {0, 1}

Operations:
- **Addition (XOR)**: 0+0=0, 0+1=1, 1+0=1, 1+1=0
- **Multiplication (AND)**: 0×0=0, 0×1=0, 1×0=0, 1×1=1

Properties:
- Addition is its own inverse: a + a = 0
- Subtraction = Addition: a - b = a + b
- No concept of "negative"

### Why This Matters

Toggle operations are XOR:
- Light off (0) + Toggle (1) = On (1)
- Light on (1) + Toggle (1) = Off (0)

Pressing button twice:
- State + Button + Button = State + (Button + Button) = State + 0 = State

This is why we only need to consider pressing each button 0 or 1 times!

## Potential Extensions

### Part 2 Speculation

Possible extensions could include:
- **Minimum Presses with Constraints**: e.g., can't press same button twice in a row
- **Sequential Configuration**: Configure machines in specific order with shared state
- **Button Cost**: Different buttons have different "costs" (not just count)
- **Timed Presses**: Lights decay over time
- **Joltage Optimization**: Use the joltage requirements in some way

## Files

- **Part 1**:
  - `solve.swift`: Main solution with brute force approach (Answer: 457)

- **Part 2**:
  - `solve_p2_pulp.py`: ILP solution using PuLP/CBC solver (Answer: 17,576) ✓
  - `solve_p2_gauss.py`: Gauss-Jordan elimination attempt (104/170 machines)
  - `solve_p2_enhanced.py`: Gauss-Jordan + greedy fallback (117/170 machines, 11,639 - incorrect)
  - `solve_p2_final.py`: Bounded search attempt (incomplete)
  - `solve_part2_simple.py`: Simple greedy approach (1/170 machines)
  - `solve_part2_milp.py`: SciPy linear programming attempt (rounding issues)

- **Other**:
  - `README.md`: This documentation
  - `test_machine1.swift`: Manual verification of Machine 1
  - Input: `/Users/angeloribeiro/Development/adventofcode/inputDay10.txt`

## Sample Output

### Part 1
```
Machine 1: 2 presses
Machine 2: 3 presses
Machine 3: 2 presses
...
Machine 170: 2 presses

Total button presses: 457
```

### Part 2
```
Solving Part 2 with PuLP ILP solver...

Machine 1: 55 presses
Machine 2: 88 presses
Machine 3: 26 presses
Machine 4: 71 presses
Machine 5: 255 presses
...
Machine 166: 19 presses
Machine 167: 118 presses
Machine 168: 159 presses
Machine 169: 69 presses
Machine 170: 87 presses

=== Part 2 Answer ===
Solved: 170/170 machines
Total presses: 17576
```

## Computational Geometry vs Linear Algebra vs Integer Optimization

This problem showcases three different mathematical domains across two parts:

| Aspect | Day 9 (Geometry) | Day 10 Part 1 (Algebra) | Day 10 Part 2 (ILP) |
|--------|------------------|-------------------------|---------------------|
| Domain | Continuous (coordinates) | Discrete (binary) | Discrete (integers) |
| Operations | Min/max, distance | XOR, modulo 2 | Addition, optimization |
| Approach | Edge-crossing detection | System of equations | Integer programming |
| Complexity | O(N³) | O(2^m × n) | NP-hard |
| Field | Real numbers | GF(2) | ℤ⁺ |
| Solver | Ray casting | Brute force | CBC (Branch & Cut) |

All three require careful mathematical modeling, but use completely different techniques!

## Key Takeaways

1. **Part 1**: Simple brute force works because buttons are binary (press 0 or 1 times)
2. **Part 2**: Integer constraints + optimization require sophisticated ILP solvers
3. **Heuristics fail**: Greedy and Gaussian elimination find solutions, but not optimal ones
4. **Use proper tools**: PuLP with CBC solver is the right tool for ILP problems
5. **Mathematical modeling**: Understanding the problem structure (GF(2) vs ℤ⁺) is crucial

## Learning Points

- **GF(2) arithmetic**: Toggle operations form a binary field
- **Integer Linear Programming**: NP-hard optimization problem requiring branch-and-cut
- **CBC solver**: Modern optimization engine using relaxation, branching, and cutting planes
- **Why heuristics fail**: Local optima don't guarantee global optimality
- **Problem transformation**: Converting real-world constraints into mathematical formulations
