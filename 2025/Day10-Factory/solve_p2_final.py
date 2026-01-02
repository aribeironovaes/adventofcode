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

def button_matrix(buttons, num_counters):
    """Convert buttons to matrix form like the friend's solution."""
    m = []
    for b in buttons:
        v = [0] * num_counters
        for i in b:
            if i < num_counters:
                v[i] = 1
        m.append(v)
    return m

def solve_ilp_simple(bm, joltage):
    """
    Solve ILP without external library using bounded search.
    This is a simpler brute-force for small systems.
    """
    num_buttons = len(bm)
    num_counters = len(joltage)

    # For each button, calculate max useful presses
    max_presses_per_button = []
    for b_idx in range(num_buttons):
        # Max presses = max joltage value for any counter this button affects
        max_needed = 0
        for c_idx in range(num_counters):
            if bm[b_idx][c_idx] > 0:
                max_needed = max(max_needed, joltage[c_idx])
        max_presses_per_button.append(max_needed if max_needed > 0 else 100)

    # Try all combinations up to reasonable bounds
    from itertools import product

    # Limit search space
    search_limits = [min(m, 200) for m in max_presses_per_button]

    best = None
    best_total = float('inf')

    # Generate candidates smartly
    def generate_candidates():
        # Start with small values
        for total_limit in range(sum(joltage) + 50):
            for combo in product(*[range(min(sl, total_limit + 1)) for sl in search_limits]):
                if sum(combo) <= total_limit:
                    yield combo

    count = 0
    for combo in generate_candidates():
        count += 1
        if count > 1000000:  # Safety limit
            break

        # Check if this combination works
        result = [0] * num_counters
        for b_idx, presses in enumerate(combo):
            for c_idx in range(num_counters):
                result[c_idx] += bm[b_idx][c_idx] * presses

        if result == joltage:
            total = sum(combo)
            if total < best_total:
                best_total = total
                best = combo
                # Early exit if we found a solution with reasonable total
                if best_total <= sum(joltage):
                    return best_total

    return best_total if best is not None else None

# Read input
with open('/Users/angeloribeiro/Development/adventofcode/inputDay10.txt', 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

total_presses = 0
solved_count = 0

print("Solving Part 2 with ILP approach...\n")

for idx, line in enumerate(lines):
    machine_num = idx + 1
    result = parse_machine(line)
    if not result:
        continue

    target, buttons, joltage = result
    bm = button_matrix(buttons, len(joltage))

    presses = solve_ilp_simple(bm, joltage)
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
