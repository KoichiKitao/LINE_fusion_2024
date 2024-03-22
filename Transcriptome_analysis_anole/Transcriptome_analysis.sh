#!/bin/bash

sra_project_id=SRP102989
outdir="path/to/outdir"

## RNA-seq analysis

for file_name in SRR54121{44..73}; do

# Triming
fastp -w 16 \
-i ./${sra_project_id}/${file_name}_1.fastq.gz \
-o ./fastp_out/${file_name}_1_trim.fq.gz \
-h ./fastp_out/${file_name}.html \
-j ./fastp_out/${file_name}.json

# Mapping to reference genomes
gunzip ./fastp_out/${file_name}_1_trim.fq.gz
STAR --runThreadN 32 \
--genomeDir ./star_index/Anolis_carolinensis/star_index \
--readFilesIn ./fastp_out/${file_name}_1_trim.fq \
--outSAMtype BAM SortedByCoordinate \
--outFileNamePrefix ./star_out/${file_name}_ \
--outSAMattributes NH HI NM MD XS AS \
--outFilterMultimapNmax 500
gzip --fast ./fastp_out/${file_name}_1_trim.fq

mkdir stringtie_out
for file_name in SRR54121{44..73}; do
stringtie -p 16 --rf \
./star_out/${file_name}_Aligned.sortedByCoord.out.bam \
-o ./stringtie_out/${file_name}.gtf
done



# generation of merge_list
mkdir stringtie_merge
for file_name in SRR54121{44..73}; do
echo './stringtie_out/'${file_name}'.gtf'
done > ./stringtie_merge/stringtie_gtf.list

# stringtie merge
stringtie --merge -p 16 -f 0.001 \
./stringtie_merge/stringtie_gtf.list \
-o ./stringtie_merge/stringtie_merge.gtf

# Read counting
mkdir featureCounts
featureCounts -T 8 -s 2 -t exon -g gene_id \
-a ./stringtie_merge/stringtie_merge.gtf \
-o ./featureCounts/featureCounts.tsv \
./star_out/SRR54121{44..73}_Aligned.sortedByCoord.out.bam

# TPM calculation
python3 featureCounts_tpm_v2.py \
./featureCounts/featureCounts.tsv \
./featureCounts/featureCounts_TPM.tsv

