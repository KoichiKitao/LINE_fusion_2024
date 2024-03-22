#!/user/bin/env python3

import sys

argvs = sys.argv
infile = str(argvs[1]) # blat psl format
outfile = str(argvs[2]) # blat psl format

n = 5
q_cover_old = 0

with open(infile, 'r') as fr:
    # skip headers
    for _ in range(5):
        next(fr)

    for line in fr:
        n += 1
        values = line.split('\t')

        match = int(values[0])
        mismatch = int(values[1])
        q_size = int(values[10])
        q_cover = round((match + mismatch) / q_size, 4)
        if q_cover > q_cover_old:
            q_cover_old = q_cover
            q_cover_max_line = n

with open(infile, 'r') as fr:
    for _ in range(q_cover_max_line-1):
        next(fr)
    for line in fr:
        values = line.split('\t')
        T_name = values[13]
        T_start = int(values[15])
        T_end = int(values[16])
        strand_1 = values[8]
        if strand_1 == '++':
            strand = '+'
            start = T_start-600
            end= T_end
        elif strand_1 == '+-':
            strand = '-'
            start = T_start
            end = T_end+600
        break

with open(outfile, 'w') as fw:
    fw.write(T_name +'\t'+ str(start) +'\t'+ str(end) +'\t.\t0\t'+ strand +'\n')
               