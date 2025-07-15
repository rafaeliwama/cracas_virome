#!/bin/sh

#SBATCH --time=2-00:00:00
#SBATCH --job-name=sortmerna
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=15gb
#SBATCH --partition=long


. ~/miniforge3/etc/profile.d/conda.sh

conda activate seqyclean

# Rename files to replace underscores with dots
# This is necessary for seqyclean to recognize paired-end files correctly
for file in *.fastq; do nname=$(echo $file | sed s/_/\./g); mv $file $nname; done

# make a list of files pairs - for paired end transcriptomes
for i in *.fastq;do echo $i| cut -d'.' -f1 >> temp1.tmp; done
cat temp1.tmp | sort | uniq > accession_list.tmp


# run seqyclean for paired ended transcriptomes
# The command assumes that the files are named with a pattern like "accession.1.fast"
cat accession_list.tmp | while read line; do 
  seqyclean -1 $line.1.fastq -2 $line.2.fastq -qual -o $line -c /home/riwama/databases/univec/univec.fasta
done
