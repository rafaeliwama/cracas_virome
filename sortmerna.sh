#!/bin/sh

#SBATCH --time=2-00:00:00
#SBATCH --job-name=sortmerna
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=15gb
#SBATCH --partition=long


. ~/miniforge3/etc/profile.d/conda.sh

conda activate sortmerna


# make a list of files pairs - for paired end transcriptomes

for i in *.fastq;do echo $i| cut -d'_' -f1 >> temp1.tmp; done

cat temp1.tmp | sort | uniq > accession_list.tmp



# run sortmerna for paired ended transcriptomes

cat accession_list.tmp | while read line; do sortmerna -ref ~/databases/sortmerna_db/smr_v4.3_default_db.fasta -reads "${line}_PE1.fq" -reads "${line}_PE2.fq" -a 16 -other -out2 -fastx -workdir sort_wd; for file in sort_wd/out/other*; do mv ~/Cracas_viroma/seqyclean_done/sort_wd/$file ~/Cracas_viroma/sortmerna_done/$line.$file; rm ~/Cracas_viroma/seqyclean_done/sort_wd/* -rf; done; done

rm *.tmp
