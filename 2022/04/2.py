import re

score = 0
with open('input.txt') as input:
    while line := input.readline():
        a, b, c, d = map(int, re.findall(r"\d+", line))
        left = range(a, b + 1)
        right = range(c, d + 1)

        if any(l in right for l in left) or any(r in left for r in right):
            score += 1

print(score)
