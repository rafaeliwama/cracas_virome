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

cat accession_list.tmp | while read line; do sortmerna -ref ~/databases/sortmerna_db/smr_v4.3_default_db.fasta -reads "${line}_PE1.fastq" -reads "${line}_PE2.fastq" -a 16 -other ~/Cracas_viroma/seqyclean_done/sort_wd/out/$line -out2 -fastx -workdir ~/Cracas_viroma/seqyclean_done/sort_wd; mv ~/Cracas_viroma/seqyclean_done/sort_wd/out/"${line}_fwd.fq" /home/riwama/Cracas_viroma/seqyclean_done/s_done; mv ~/Cracas_viroma/seqyclean_done/sort_wd/out/"${line}_rev.fq" /home/riwama/Cracas_viroma/seqyclean_done/s_done; rm ~/Cracas_viroma/seqyclean_done/sort_wd/* -rf; done

rm *.tmp

mv s_done/*.fq ~/Cracas_viroma/sortmerna_done/

rm *.fastq