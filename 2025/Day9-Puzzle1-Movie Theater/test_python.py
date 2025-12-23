#!/usr/bin/env python3

def area(p1, p2):
    return (abs(p1[0] - p2[0]) + 1) * (abs(p1[1] - p2[1]) + 1)

def is_valid(data, i, j):
    x1 = min(data[i][0], data[j][0])
    x2 = max(data[i][0], data[j][0])
    y1 = min(data[i][1], data[j][1])
    y2 = max(data[i][1], data[j][1])

    for k in range(len(data)):
        x, y = data[k]
        xp, yp = data[k - 1]

        # Check 1: No vertex strictly inside rectangle
        if x1 < x < x2 and y1 < y < y2:
            return False

        # Check 2: Edge crosses left/right boundary
        if x1 < x < x2 and y <= y1 and y1 < yp:
            return False
        if x1 < x < x2 and yp <= y1 and y1 < y:
            return False

        # Check 3: Edge crosses top/bottom boundary
        if y1 < y < y2 and x <= x1 and x1 < xp:
            return False
        if y1 < y < y2 and xp <= x1 and x1 < x:
            return False

    return True

# Read input
with open('Inputs/test_new.txt', 'r') as f:
    lines = f.read().strip().split('\n')

data = []
for line in lines:
    coords = [int(x.strip()) for x in line.split(',')]
    data.append((coords[0], coords[1]))

print(f"Read {len(data)} red tiles")

# Part 1: Max area without validation
max_area1 = 0
max_i1, max_j1 = 0, 0
for i in range(len(data)):
    for j in range(i):
        a = area(data[i], data[j])
        if a > max_area1:
            max_area1 = a
            max_i1 = i
            max_j1 = j

print(f"\nPart 1: {max_area1}")
print(f"  Corners: {data[max_i1]} to {data[max_j1]}")

# Part 2: Max area with validation
max_area2 = 0
max_i2, max_j2 = 0, 0
for i in range(len(data)):
    for j in range(i):
        a = area(data[i], data[j])
        if a > max_area2 and is_valid(data, i, j):
            max_area2 = a
            max_i2 = i
            max_j2 = j

print(f"\nPart 2: {max_area2}")
print(f"  Corners: {data[max_i2]} to {data[max_j2]}")
