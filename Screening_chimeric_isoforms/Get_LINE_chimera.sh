#!/bin/bash

outdir="path/to/dir"
mkdir $outdir
cd $outdir

refseq="path/to/refseq_protein.fa"
dfam="path/to/Dfam_protein.fa"
name=vertebrate_other

# Retrieve protein isoform
seqkit grep -n -r -p isoform ${refseq} > ./${name}_isoform.fa

# Remove uncheracterized protein
seqkit grep -n -r -p uncharacterized -v ./${name}_isoform.fa > ./${name}_isoform_rm_unch.fa
rm ./${name}_isoform.fa

## MMseqs analysis
mkdir -p ./MMseqs_out/DB
mkdir -p ./MMseqs_out/tmp

# Query database (Refseq proteins)
mmseqs createdb ./${name}_isoform_rm_unch.fa ./MMseqs_out/DB/${name}_query_DB

# Target database (LINE ORF1 proteins)
mmseqs createdb ${dfam} ./MMseqs_out/DB/target_DB
mmseqs createindex ./MMseqs_out/DB/target_DB ./MMseqs_out/tmp

# search
mmseqs search --max-seqs 5 -e 1E-10 \
./MMseqs_out/DB/${name}_query_DB \
./MMseqs_out/DB/target_DB \
./MMseqs_out/DB/${name}_result_DB \
./MMseqs_out/tmp

# make blast-like format
mmseqs convertalis --format-output "query,target,evalue,qlen,qstart,qend,tlen,tstart,tend,qcov,tcov,pident,bits" \
./MMseqs_out/DB/${name}_query_DB \
./MMseqs_out/DB/target_DB \
./MMseqs_out/DB/${name}_result_DB \
./MMseqs_out/${name}_RefSeq_LINE.out

# get target cover rate more than 0.5
awk -F'\t' '$11 >= 0.5' ./MMseqs_out/${name}_RefSeq_LINE.out > ./MMseqs_out/${name}_RefSeq_LINE_0.5.out

# convert MMseq_out to simple tsv file of ID and target for further analysis
python3 blast_table_v2.py \
./MMseqs_out/${name}_RefSeq_LINE_0.5.out \
./MMseqs_out/${name}_RefSeq_LINE_0.5_simple.tsv

#get ID, protein_name, and species
seqkit seq -n ./${name}_isoform_rm_unch.fa > ./${name}_isoform_rm_unch.txt
python3 RefSeq_table.py ./${name}_isoform_rm_unch.txt ./${name}_RefSeq_table.tsv

# get LINE isoforms meeting our criteria
python3 RefSeq_LINE_chimera.py \
./${name}_RefSeq_table.tsv \
./MMseqs_out/${name}_RefSeq_LINE_0.5_simple.tsv \
./${name}_RefSeq_LINE.tsv
