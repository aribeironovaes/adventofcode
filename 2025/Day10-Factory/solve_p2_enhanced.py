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

def solve_underdetermined(A, b, num_vars):
    """
    For under-determined systems, try to find minimal solution
    by enumerating small values for free variables.
    """
    n_rows = len(A)
    max_val = max(b) if b else 50

    # Try simple greedy: press buttons that contribute most to deficit
    from collections import defaultdict

    best_solution = None
    best_total = float('inf')

    # Try different strategies
    for strategy in range(3):
        counters = [0] * n_rows
        presses = [0] * num_vars

        for _ in range(sum(b) * 2):  # Safety limit
            if counters == b:
                total = sum(presses)
                if total < best_total:
                    best_total = total
                    best_solution = presses[:]
                break

            # Find counter with largest deficit
            max_deficit = 0
            target_counter = -1
            for i in range(n_rows):
                if counters[i] < b[i]:
                    deficit = b[i] - counters[i]
                    if deficit > max_deficit:
                        max_deficit = deficit
                        target_counter = i

            if target_counter == -1:
                break

            # Find best button
            best_button = -1
            best_score = -1

            for button_idx in range(num_vars):
                if A[target_counter][button_idx] == 0:
                    continue

                # Check if this helps and doesn't overshoot
                score = 0
                valid = True
                for counter_idx in range(n_rows):
                    if A[counter_idx][button_idx] > 0:
                        if counters[counter_idx] >= b[counter_idx]:
                            valid = False
                            break
                        else:
                            score += 1

                if valid:
                    if strategy == 0:  # Greedy: first valid
                        best_button = button_idx
                        break
                    elif strategy == 1:  # Max help
                        if score > best_score:
                            best_score = score
                            best_button = button_idx
                    else:  # Prefer buttons affecting target
                        if A[target_counter][button_idx] > 0:
                            if score > best_score:
                                best_score = score
                                best_button = button_idx

            if best_button == -1:
                break

            # Press button
            presses[best_button] += 1
            for counter_idx in range(n_rows):
                counters[counter_idx] += A[counter_idx][best_button]

    return best_solution

def gauss_jordan(A, b):
    """Solve Ax = b using Gauss-Jordan elimination."""
    n_rows = len(A)
    n_cols = len(A[0])

    # Create augmented matrix
    aug = []
    for i in range(n_rows):
        row = [Fraction(A[i][j]) for j in range(n_cols)]
        row.append(Fraction(b[i]))
        aug.append(row)

    # Forward elimination with partial pivoting
    pivot_cols = []
    pivot_row = 0

    for col in range(n_cols):
        if pivot_row >= n_rows:
            break

        # Find best pivot in this column
        max_row = None
        max_val = Fraction(0)
        for row in range(pivot_row, n_rows):
            if abs(aug[row][col]) > abs(max_val):
                max_val = aug[row][col]
                max_row = row

        if max_val == 0:
            continue  # This column is free

        # Swap rows
        aug[pivot_row], aug[max_row] = aug[max_row], aug[pivot_row]

        # Scale pivot row
        pivot = aug[pivot_row][col]
        for j in range(n_cols + 1):
            aug[pivot_row][j] /= pivot

        # Eliminate column in all other rows
        for i in range(n_rows):
            if i != pivot_row and aug[i][col] != 0:
                factor = aug[i][col]
                for j in range(n_cols + 1):
                    aug[i][j] -= factor * aug[pivot_row][j]

        pivot_cols.append(col)
        pivot_row += 1

    # Check for inconsistency
    for i in range(pivot_row, n_rows):
        if aug[i][n_cols] != 0:
            return None  # Inconsistent system

    # Extract basic solution (set non-pivot variables to 0)
    solution = [Fraction(0)] * n_cols
    for i, col in enumerate(pivot_cols):
        solution[col] = aug[i][n_cols]

    # Convert to integers
    result = []
    for x in solution:
        if x.denominator != 1:
            return None
        val = int(x)
        if val < 0:
            return None
        result.append(val)

    # Verify solution
    for i in range(n_rows):
        total = sum(A[i][j] * result[j] for j in range(n_cols))
        if total != b[i]:
            return None

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

    # Try exact solution first
    solution = gauss_jordan(A, joltage)
    if solution:
        return sum(solution)

    # If that fails, try heuristic for under-determined system
    solution = solve_underdetermined(A, joltage, num_buttons)
    if solution:
        # Verify
        counters = [0] * num_counters
        for button_idx, presses in enumerate(solution):
            for counter_idx in range(num_counters):
                counters[counter_idx] += A[counter_idx][button_idx] * presses
        if counters == joltage:
            return sum(solution)

    return None

# Read input
with open('/Users/angeloribeiro/Development/adventofcode/inputDay10.txt', 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

total_presses = 0
solved_count = 0

print("Solving Part 2 with enhanced solver...\n")

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
            print(f"Machine {machine_num}: FAILED")

print(f"\n=== Part 2 Answer ===")
print(f"Solved: {solved_count}/{len(lines)} machines")
print(f"Total presses: {total_presses}")
