# Workflow after blat search

## Input of examples
```
clade=Crocodile
naf_dir="path/to/genome_naf_directory"
```

## Make bed file with flanking sequences
```
#  Make bed file with flanking seqnences (upstream and downstream) from blat result tables
mkdir -p bed/${clade}

sample_name=`basename "${naf_path}" | sed -e "s/\.naf//" | sed -e "s/\s/_/g"`
python3 blat_get_flank.py \
./blat_out/${clade}/${sample_name}.tsv \
./bed/${clade}/${sample_name}.bed
done < <(ls -1 ${naf_dir}/${clade}/*.naf)
```
## Get fasta files using bed files generated above and extract ORFs

```
mkdir -p out_fasta/${clade}
mkdir -p getorf_out/${clade}

while read naf_path; do
sample_name=`basename "${naf_path}" | sed -e "s/\.naf//" | sed -e "s/\s/_/g"`

fasta=./fasta/${clade}/${sample_name}.fna
bed=./bed/${clade}/${sample_name}.bed
out_fasta=./out_fasta/${clade}/${sample_name}.fa
orf=./getorf_out/${clade}/${sample_name}.fa

# getfasta
bedtools getfasta -s -fi ${fasta} -bed ${bed} -fo ${out_fasta}
    
# getorf
getorf -find 3 -minsize 600 -reverse No -sequence ${out_fasta} -outseq ${orf}

done < <(ls -1 ${naf_dir}/${clade}/*.naf)

# delete o byte files (i.e. Species in which ORF was not detected)
find ./getorf_out/${clade} -empty -delete

# Rename fasta names from original getorf output
mkdir -p ./rename_fasta/${clade}
while read path; do
sample_name=`basename "${path}" | sed -e "s/\.fa//"`
sp_name=`echo $sample_name | sed -e "s/_\[.*\]//"`

python3 fasta_rename.py \
./getorf_out/${clade}/${sample_name}.fa \
./rename_fasta/${clade}/${sample_name}.fa \
$sp_name

done < <(ls -1 ./getorf_out/${clade}/*.fa)
```

## Extract Lyosin's exon L from ORFs
```
# ORFs are translated and merged to a single multi-fasta file for alignment
mkdir -p ./merged_fasta/${clade}
cat ./rename_fasta/${clade}/*.fa > ./merged_fasta/${clade}/merged_fasta.fa
seqkit translate ./merged_fasta/${clade}/merged_fasta.fa > ./merged_fasta/${clade}/merged_fasta_aa.fa

##ORFs were pre-aligned
mafft --reorder ./merged_fasta/${clade}/merged_fasta_aa.fa > ./merged_fasta/${clade}/merged_fasta_aa_pre.aln
```

Note: After the alignment, sequences aligned to previously identified Lyosin sequences are retrieved manually.


## Investigate intactness of exon X1
```
# Re-alingment of Lyosin proteins
mafft --reorder ./merged_fasta/${clade}/merged_fasta_aa.aln > ./merged_fasta/${clade}/merged_fasta_aa_2.aln

# Get sequence names of Lyosin proteins
seqkit seq -n ./merged_fasta/${clade}/merged_fasta_aa_2.aln > ./merged_fasta/${clade}/merged_fasta_aa_2.txt

# Get Lyosin coding sequences (CDS) as nucleotide acids
seqkit grep -f ./merged_fasta/${clade}/merged_fasta_aa_2.txt ./merged_fasta/${clade}/merged_fasta.fa > ./merged_fasta/${clade}/Lyosin_cds.fa

# Align the coding sequences
linsi --reorder ./merged_fasta/${clade}/Lyosin_cds.fa > ./merged_fasta/${clade}/Lyosin_cds.aln
```

Note: After the alignment, sequences sharing 5'-splice site with alligator Lyosin are retrieved.


## Final alignment of intact exon L (codon alignment)
```
# Remove "-" from alignment for translate
sed -e "s/-//g" ./merged_fasta/${clade}/Lyosin_cds_exon.aln > ./merged_fasta/${clade}/Lyosin_cds_exon.fa

# Translate
seqkit translate ./merged_fasta/${clade}/Lyosin_cds_exon.fa > ./merged_fasta/${clade}/Lyosin_cds_exon_aa.fa

# Amino acid alignment
linsi --reorder ./merged_fasta/${clade}/Lyosin_cds_exon_aa.fa > ./merged_fasta/${clade}/Lyosin_cds_exon_aa.aln

# Make codon alignment of Lyosin's exon L
pal2nal.pl \
./merged_fasta/${clade}/Lyosin_cds_exon_aa.aln \
./merged_fasta/${clade}/Lyosin_cds_exon.fa \
-output fasta \
> ./merged_fasta/${clade}/Lyosin_cds_exon_codon.aln
```
