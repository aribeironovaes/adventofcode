#!/usr/bin/env python3
import re
from scipy.optimize import linprog
import numpy as np

def parse_machine(line):
    # Extract lights pattern
    lights_match = re.search(r'\[(.*?)\]', line)
    if not lights_match:
        return None

    lights_str = lights_match.group(1)
    target = [1 if c == '#' else 0 for c in lights_str]

    # Extract buttons
    buttons = []
    button_matches = re.findall(r'\(([0-9,\s]+)\)', line)
    for match in button_matches:
        lights = [int(x.strip()) for x in match.split(',')]
        buttons.append(lights)

    # Extract joltage
    joltage_match = re.search(r'\{([0-9,\s]+)\}', line)
    joltage = []
    if joltage_match:
        joltage = [int(x.strip()) for x in joltage_match.group(1).split(',')]

    return target, buttons, joltage

def solve_part2_milp(buttons, joltage):
    num_buttons = len(buttons)
    num_counters = len(joltage)

    # Create coefficient matrix A
    # A[i][j] = 1 if button j affects counter i
    A = np.zeros((num_counters, num_buttons), dtype=int)

    for button_idx, button in enumerate(buttons):
        for counter in button:
            if counter < num_counters:
                A[counter][button_idx] = 1

    # We want to minimize sum(x) subject to: Ax = b, x >= 0, x integer
    # linprog minimizes c^T x subject to: A_eq x = b_eq, A_ub x <= b_ub, bounds

    c = np.ones(num_buttons)  # Minimize sum of button presses
    b_eq = np.array(joltage)

    # Try with linprog (relaxed integer solution)
    bounds = [(0, None) for _ in range(num_buttons)]

    result = linprog(c, A_eq=A, b_eq=b_eq, bounds=bounds, method='highs')

    if result.success:
        # Round to integers and verify
        x_rounded = np.round(result.x).astype(int)
        result_counters = A @ x_rounded

        if np.array_equal(result_counters, b_eq):
            return int(np.sum(x_rounded))

        # Try other rounding strategies
        for strategy in ['floor', 'ceil']:
            if strategy == 'floor':
                x_test = np.floor(result.x).astype(int)
            else:
                x_test = np.ceil(result.x).astype(int)

            result_counters = A @ x_test
            if np.array_equal(result_counters, b_eq):
                return int(np.sum(x_test))

    return None

# Read input
with open('/Users/angeloribeiro/Development/adventofcode/inputDay10.txt', 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

total_presses = 0
solved_count = 0

print("Solving Part 2 with MILP approach...\n")

for idx, line in enumerate(lines):
    machine_num = idx + 1
    result = parse_machine(line)
    if not result:
        continue

    target, buttons, joltage = result

    presses = solve_part2_milp(buttons, joltage)
    if presses is not None:
        total_presses += presses
        solved_count += 1
        if machine_num <= 5 or machine_num > 165:
            print(f"Machine {machine_num}: {presses} presses")
        elif machine_num == 6:
            print("...")
    else:
        print(f"Machine {machine_num}: FAILED")

print(f"\n=== Part 2 Answer ===")
print(f"Solved: {solved_count}/{len(lines)} machines")
print(f"Total presses: {total_presses}")
