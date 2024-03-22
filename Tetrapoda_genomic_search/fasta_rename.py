#!/usr/bin/env python3

import sys, re
argvs = sys.argv

fasta = str(argvs[1])
outfile = str(argvs[2])
prefix = str(argvs[3])

seq_d = {}
N = 1
for line in open(fasta):
    line = line.strip()
    if '>' in line:
        name=f'{prefix}_{N}'
        seq_d[name] = ''
        N += 1
    else:
        seq = line
        seq_d[name] = seq_d[name] + seq
        
with open(outfile, 'w') as f:
    for k in seq_d.keys():
        seq = seq_d[k]
        f.write('>' + k + '\n')
        f.write(seq + '\n')
        