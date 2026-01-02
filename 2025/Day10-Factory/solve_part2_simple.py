#!/usr/bin/env python3
import re

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

def solve_part2_simple(buttons, joltage):
    """
    Solve using simple enumeration with smart bounds.
    For each machine, try small values first.
    """
    num_buttons = len(buttons)
    num_counters = len(joltage)

    # Create coefficient matrix
    A = [[0] * num_buttons for _ in range(num_counters)]

    for button_idx, button in enumerate(buttons):
        for counter in button:
            if counter < num_counters:
                A[counter][button_idx] = 1

    # For small machines, try exhaustive search with limited range
    if num_buttons <= 6 and max(joltage) <= 50:
        max_val = max(joltage) + 10
        return exhaustive_search(A, joltage, num_buttons, num_counters, max_val)

    # For larger machines, use heuristics
    # Try to find any valid solution
    solution = find_any_solution(A, joltage, num_buttons, num_counters)
    return solution

def exhaustive_search(A, joltage, num_buttons, num_counters, max_val):
    """Try all combinations up to max_val for each button."""
    from itertools import product

    best = None
    for combo in product(range(max_val + 1), repeat=num_buttons):
        # Calculate result
        result = [0] * num_counters
        for button_idx, presses in enumerate(combo):
            for counter_idx in range(num_counters):
                result[counter_idx] += A[counter_idx][button_idx] * presses

        if result == joltage:
            total = sum(combo)
            if best is None or total < best:
                best = total

    return best

def find_any_solution(A, joltage, num_buttons, num_counters):
    """
    Use greedy approach or simple heuristics to find a solution.
    """
    # Try the "divide and conquer" approach
    # For each counter, try to satisfy it independently first
    solution = [0] * num_buttons

    counters = [0] * num_counters

    max_iterations = sum(joltage) * 2

    for _ in range(max_iterations):
        if counters == joltage:
            return sum(solution)

        # Find counter that needs most work
        max_deficit = 0
        target_counter = -1
        for i in range(num_counters):
            if counters[i] < joltage[i]:
                deficit = joltage[i] - counters[i]
                if deficit > max_deficit:
                    max_deficit = deficit
                    target_counter = i

        if target_counter == -1:
            return None  # All counters satisfied

        # Find button that helps this counter most without overshooting others
        best_button = -1
        for button_idx in range(num_buttons):
            if A[target_counter][button_idx] == 0:
                continue

            # Check if pressing this button would overshoot any counter
            valid = True
            for counter_idx in range(num_counters):
                if A[counter_idx][button_idx] > 0:
                    if counters[counter_idx] >= joltage[counter_idx]:
                        valid = False
                        break

            if valid:
                best_button = button_idx
                break

        if best_button == -1:
            return None  # Can't make progress

        # Press the button
        solution[best_button] += 1
        for counter_idx in range(num_counters):
            counters[counter_idx] += A[counter_idx][best_button]

    return None  # Failed to converge

# Read input
with open('/Users/angeloribeiro/Development/adventofcode/inputDay10.txt', 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

total_presses = 0
solved_count = 0

print("Solving Part 2 with simple approach...\n")

for idx, line in enumerate(lines):
    machine_num = idx + 1
    result = parse_machine(line)
    if not result:
        continue

    target, buttons, joltage = result

    presses = solve_part2_simple(buttons, joltage)
    if presses is not None:
        total_presses += presses
        solved_count += 1
        if machine_num <= 5 or machine_num > 165:
            print(f"Machine {machine_num}: {presses} presses")
        elif machine_num == 6:
            print("...")
    else:
        if machine_num <= 5:
            print(f"Machine {machine_num}: FAILED")

print(f"\n=== Part 2 Answer ===")
print(f"Solved: {solved_count}/{len(lines)} machines")
print(f"Total presses: {total_presses}")
