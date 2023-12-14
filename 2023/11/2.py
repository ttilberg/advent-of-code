import numpy as np

def main(fn , pt2=True):
    with open(fn) as f:
        lines = [[*line.strip()] for line in f]
    f.close

    universe = np.array(lines)
    
    er,ec = [],[]
    for i, row in enumerate(universe):
        if all([v=='.' for v in row]):
            er.append(i)
    
    for j, col in enumerate(universe.T):
        if all([v=='.' for v in col]):
            ec.append(j)

    expRate = 1000000-1 if pt2 else 1
    
    coords = []
    for row, line in enumerate(universe):
        for col, char in enumerate(line):
            if char == '#':
                coords.append([row,col])
    

    dists = []
    for i, [row,col] in enumerate(coords):
        for j in range(i+1,len(coords)):
            trow, tcol = coords[j]

            xrow, nrow = max(trow,row), min(trow,row)
            xcol, ncol = max(tcol,col), min(tcol,col)
            add = 0
            for t in ec:
                if t > ncol and t < xcol:
                    add += expRate
            for t in er:
                if t > nrow and t < xrow:
                    add += expRate

            dists.append(abs(trow-row)+abs(tcol-col) + add)
    return sum(dists)
    

fn = 'input.txt'

print(f"pt2: {main(fn)}")
