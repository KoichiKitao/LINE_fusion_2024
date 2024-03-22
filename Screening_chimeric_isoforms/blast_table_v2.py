#!/user/bin/env python3

import sys

argvs = sys.argv
infile = str(argvs[1])
outfile = str(argvs[2])

d = {}
with open(infile, 'r') as f:
    for line in f:
        line = line.rstrip()       
        if line.startswith('#'):
            continue
        else:
            l = line.split()
            query = l[0]
            d[query] = []

with open(infile, 'r') as f:
    for line in f:
        line = line.rstrip()       
        if line.startswith('#'):
            continue
        else:
            l = line.split()
            query = l[0]
            d[query].append(l[1])
            
f = open(outfile, 'w')
for k in d.keys():
    subject = ",".join(d[k])
    f.write(k + '\t')
    f.write(subject + '\n')
f.close()