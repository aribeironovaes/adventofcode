#!/usr/bin/env python3
import re
import pulp as pl

def parse_machine(line):
    """Parse machine specification from input line."""
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
    """Convert buttons to matrix form: bm[button_idx][counter_idx] = 1 if button affects counter."""
    bm = []
    for button in buttons:
        row = [0] * num_counters
        for counter in button:
            if counter < num_counters:
                row[counter] = 1
        bm.append(row)
    return bm

def solve_ilp(buttons, joltage):
    """
    Solve using Integer Linear Programming with PuLP.
    Minimize: sum of button presses
    Subject to: sum(bm[i][j] * b[i]) = joltage[j] for all counters j
                b[i] >= 0 for all buttons i
                b[i] is integer
    """
    num_buttons = len(buttons)
    num_counters = len(joltage)

    # Create button matrix
    bm = button_matrix(buttons, num_counters)

    # Create ILP problem
    prob = pl.LpProblem("MinimizeButtonPresses", pl.LpMinimize)

    # Create integer variables for button presses
    bi = range(num_buttons)
    b = pl.LpVariable.dicts("b", bi, lowBound=0, cat="Integer")

    # Objective: minimize total button presses
    prob += pl.lpSum(b[i] for i in bi), "Minimize_Total_Presses"

    # Constraints: each counter must reach its joltage target
    for j in range(num_counters):
        prob += (
            pl.lpSum(bm[i][j] * b[i] for i in bi) == joltage[j],
            f"Counter_{j}_Target"
        )

    # Solve using CBC solver (suppress output)
    prob.solve(pl.PULP_CBC_CMD(msg=False))

    # Check if solution found
    if prob.status != pl.LpStatusOptimal:
        return None

    # Extract solution
    button_presses = [int(b[i].varValue) for i in bi]
    total_presses = sum(button_presses)

    return total_presses

# Read input
with open('/Users/angeloribeiro/Development/adventofcode/inputDay10.txt', 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

total_presses = 0
solved_count = 0

print("Solving Part 2 with PuLP ILP solver...\n")

for idx, line in enumerate(lines):
    machine_num = idx + 1
    result = parse_machine(line)
    if not result:
        continue

    target, buttons, joltage = result

    presses = solve_ilp(buttons, joltage)
    if presses is not None:
        total_presses += presses
        solved_count += 1
        if machine_num <= 5 or machine_num > 165:
            print(f"Machine {machine_num}: {presses} presses")
        elif machine_num == 6:
            print("...")
    else:
        if machine_num <= 10:
            print(f"Machine {machine_num}: FAILED (no solution)")

print(f"\n=== Part 2 Answer ===")
print(f"Solved: {solved_count}/{len(lines)} machines")
print(f"Total presses: {total_presses}")
