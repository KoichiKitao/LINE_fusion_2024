#!/user/bin/env python3

import pandas as pd
import sys

argvs = sys.argv
file_refseq_table = str(argvs[1])
file_LINE_hit = str(argvs[2])
file_LINE_isoform_shared = str(argvs[3])

df_all = pd.read_table(file_refseq_table, header=None)

# get the protein_name and species from LINE isoform and nonLINE isoform as sets
with open(file_LINE_hit, 'r') as f:
    ls_LINE_ID = [line.split('\t')[0].strip() for line in f]
set_LINE = set()
set_nonLINE = set()
for index, row in df_all.iterrows():
    if row['ID'] in ls_LINE_ID:
        set_LINE.add((row['protein_name'], row['species']))
    else:
        set_nonLINE.add((row['protein_name'], row['species']))
 
# get protein_name and species shared in set of LINE isoform and nonLINE isoform 
set_both = set_LINE & set_nonLINE
df_both = pd.DataFrame(set_both, columns=['protein_name', 'species'])

# add genus column for investigate conservation between genera
df_both['genus'] = df_both['species'].str.split().str[0]

# get protein_names with alternative LINE isoform which are shared among more than two genera           
protein_multi_genus = df_both.groupby('protein_name')['genus'].nunique().reset_index(name='unique_count')
protein_multi_genus = protein_multi_genus[protein_multi_genus['unique_count'] >= 2]['protein_name'].tolist()
df_protein_multi_genus = df_both[df_both['protein_name'].isin(protein_multi_genus)]

# add IDs to each rows by merging with annotation table
df = pd.merge(df_all, df_protein_multi_genus, on=['protein_name', 'species'], how='right')

# merge with information of the hit LINE query
df_LINE = pd.read_table(file_LINE_hit, sep='\t', header=None)
df_LINE.columns = ['ID', 'LINE']
pd.merge(df, df_LINE, on='ID', how='inner').to_csv(file_LINE_isoform_shared, sep='\t', header=True, index=None)

