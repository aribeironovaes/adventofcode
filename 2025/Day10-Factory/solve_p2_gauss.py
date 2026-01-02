#!/usr/bin/env python3
import re
from fractions import Fraction

def parse_machine(line):
    lights_match = re.search(r'\[(.*?)\]', line)
    if not lights_match:
        return None

    lights_str = lights_match.group(1)
    target = [1 if c == '#' else 0 for c in lights_str]

    buttons = []
    button_matches = re.findall(r'\(([0-9,\s]+)\)', line)
    for match in button_matches:
        lights = [int(x.strip()) for x in match.split(',')]
        buttons.append(lights)

    joltage_match = re.search(r'\{([0-9,\s]+)\}', line)
    joltage = []
    if joltage_match:
        joltage = [int(x.strip()) for x in joltage_match.group(1).split(',')]

    return target, buttons, joltage

def gauss_jordan(A, b):
    """
    Solve Ax = b using Gauss-Jordan elimination with rational arithmetic.
    Returns a particular solution if it exists, or None.
    """
    n_rows = len(A)
    n_cols = len(A[0])

    # Create augmented matrix using Fractions for exact arithmetic
    aug = []
    for i in range(n_rows):
        row = [Fraction(A[i][j]) for j in range(n_cols)]
        row.append(Fraction(b[i]))
        aug.append(row)

    # Forward elimination
    pivot_col = 0
    for row in range(n_rows):
        if pivot_col >= n_cols:
            break

        # Find pivot
        max_row = row
        for i in range(row + 1, n_rows):
            if abs(aug[i][pivot_col]) > abs(aug[max_row][pivot_col]):
                max_row = i

        if aug[max_row][pivot_col] == 0:
            pivot_col += 1
            continue

        # Swap rows
        aug[row], aug[max_row] = aug[max_row], aug[row]

        # Scale pivot row
        pivot = aug[row][pivot_col]
        for j in range(n_cols + 1):
            aug[row][j] /= pivot

        # Eliminate column
        for i in range(n_rows):
            if i != row and aug[i][pivot_col] != 0:
                factor = aug[i][pivot_col]
                for j in range(n_cols + 1):
                    aug[i][j] -= factor * aug[row][j]

        pivot_col += 1

    # Extract solution (set free variables to 0)
    solution = [Fraction(0)] * n_cols
    for i in range(min(n_rows, n_cols)):
        # Find leading 1
        for j in range(n_cols):
            if aug[i][j] == 1:
                # Check if this is the only non-zero in this row before RHS
                is_leading = all(aug[i][k] == 0 for k in range(j))
                if is_leading:
                    solution[j] = aug[i][n_cols]
                break

    # Verify solution
    for i in range(n_rows):
        total = sum(A[i][j] * solution[j] for j in range(n_cols))
        if total != b[i]:
            return None  # No solution

    # Convert to integers if possible
    result = []
    for x in solution:
        if x.denominator != 1:
            return None  # Not an integer solution
        val = int(x)
        if val < 0:
            return None  # Negative solution
        result.append(val)

    return result

def solve_machine(buttons, joltage):
    num_buttons = len(buttons)
    num_counters = len(joltage)

    # Build coefficient matrix
    A = [[0] * num_buttons for _ in range(num_counters)]
    for button_idx, button in enumerate(buttons):
        for counter in button:
            if counter < num_counters:
                A[counter][button_idx] = 1

    solution = gauss_jordan(A, joltage)
    if solution:
        return sum(solution)
    return None

# Read input
with open('/Users/angeloribeiro/Development/adventofcode/inputDay10.txt', 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

total_presses = 0
solved_count = 0

print("Solving Part 2 with Gauss-Jordan elimination...\n")

for idx, line in enumerate(lines):
    machine_num = idx + 1
    result = parse_machine(line)
    if not result:
        continue

    target, buttons, joltage = result

    presses = solve_machine(buttons, joltage)
    if presses is not None:
        total_presses += presses
        solved_count += 1
        if machine_num <= 5 or machine_num > 165:
            print(f"Machine {machine_num}: {presses} presses")
        elif machine_num == 6:
            print("...")
    else:
        if machine_num <= 10:
            print(f"Machine {machine_num}: FAILED (no valid solution)")

print(f"\n=== Part 2 Answer ===")
print(f"Solved: {solved_count}/{len(lines)} machines")
print(f"Total presses: {total_presses}")
