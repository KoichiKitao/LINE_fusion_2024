#!/bin/bash

## Blat search

# Values to set
clade=Crocodile
naf_dir="path/to/genome_naf_directory"

# Example of naf file name "Acanthisitta chloris [refseq GCF_5F000695815.1 2014-05-27].naf"
mkdir -p ./fasta/${clade}
mkdir -p ./blat_out/${clade}

while read naf_path; do
sample_name=`basename "${naf_path}" | sed -e "s/\.naf//" | sed -e "s/\s/_/g"`
fasta=./fasta/${clade}/${sample_name}.fna
blat_output=./blat_out/${clade}/${sample_name}.tsv
query=./query/blat_query_Lyosin.fa

# unnaf
unnaf "${naf_path}" > ${fasta}

# blat search
blat -q=prot -t=dnax ${fasta} ${query} ${blat_output}

done < <(ls -1 ${naf_dir}/${clade}/*.naf)


## Get query cover
mkdir qcov_tsv
while read blat_output; do
sample_name=`basename "${blat_output}" | sed -e "s/\.tsv//"`
output=./qcov_tsv/${clade}.qcov.tsv
q_cov=`python3 blat_max_qcov.py ${blat_output}`
echo -e ${sample_name}'\t'${q_cov} >> ${output}
done < <(ls -1 ./blat_out/${clade}/*.tsv)


