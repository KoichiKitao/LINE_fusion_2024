#!/user/bin/env python3
  
import sys

argvs = sys.argv
infile = str(argvs[1]) # blat psl format

ls_q_cover = []
with open(infile, 'r') as fr:
    # skip headers
    for _ in range(5):
        next(fr)

    for line in fr:
        values = line.split('\t')

        match = int(values[0])
        mismatch = int(values[1])
        q_size = int(values[10])
        q_cover = round((match + mismatch) / q_size, 4)
        ls_q_cover.append(q_cover)

print(max(ls_q_cover))