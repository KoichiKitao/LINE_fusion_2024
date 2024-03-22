#!/user/bin/env python3

import re
import sys

argvs = sys.argv
file_refseq_ori = str(argvs[1])
file_refseq_mod = str(argvs[2])

# Make table of RefSeq proteins
with open(file_refseq_ori, 'r') as fr, open(file_refseq_mod, 'w') as fw:
    for line in fr:
        line = line.strip()
        
        # get protein_ID
        ID = line.split(' ', 1)[0].strip()
        
        # get protein_name and species_name from annotation
        annotation = line.split(' ', 1)[1].strip()

        # get protein_name
        protein_name = re.split('[\[\]]', annotation)[0]
        protein_name = protein_name.replace('PREDICTED:', '').replace('LOW QUALITY PROTEIN:', '').strip()
        protein_name = re.sub(r',\spartial$', '', protein_name).strip()
        protein_name = re.sub(r'isoform.+$', '', protein_name).strip()
        protein_name = protein_name.strip()

        # get species_name
        species = re.split('[\[\]]', annotation)[-2].strip()

        # write down
        fw.write(ID+'\t'+protein_name+'\t'+species+'\n')

