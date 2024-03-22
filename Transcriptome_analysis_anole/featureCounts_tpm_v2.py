#!/user/bin/env python3

import pandas as pd
import sys

argvs = sys.argv
infile = str(argvs[1])
outfile = str(argvs[2])

# load featureCount table
df_fc = pd.read_table(infile, header=1) 
df_tpm = pd.DataFrame({'Gene_id':df_fc['Geneid']})

sample_list = df_fc.columns.values.tolist()[6:]

for sample_name in sample_list:
    # Read-counts per 1 kb per gene
    df_fc['counts_per_kb'] = df_fc[sample_name]/df_fc['Length']*1000
    
    # Sum of read-counts per 1 kb per gene
    counts_per_kb_sum = df_fc['counts_per_kb'].sum()

    df_tpm[sample_name] = df_fc['counts_per_kb']/counts_per_kb_sum * 1000000

df_tpm.to_csv(outfile, sep = '\t', header = True, index = False)