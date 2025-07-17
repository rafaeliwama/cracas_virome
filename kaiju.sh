#!/bin/sh

#SBATCH --time=2-00:00:00
#SBATCH --job-name=sortmerna
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=15gb
#SBATCH --partition=long


. ~/miniforge3/etc/profile.d/conda.sh


## fix files from sortmerna with BBmap repair.sh
conda activate BBmap

for FILE in *_PE1.fastq; do
  BASENAME="${FILE/_PE1.fastq/}"
  repair.sh in1="$FILE" in2="${BASENAME}_PE2.fastq" out1="${BASENAME}_PE1_fixed.fastq" out2="${BASENAME}_PE2_fixed.fastq"
done

conda deactivate BBmap

## runs Kaiju to classify the reads
conda activate kaiju

for FILE in *_PE1.fastq; do
    BASENAME="${FILE/_PE1_fixed.fastq/}"
    kaiju -E 10-5 -v -z 16 -t ~/databases/kaijudb/nodes.dmp -f ~/databases/kaijudb/viruses/kaiju_db_viruses.fmi -i $FILE -j "${BASENAME}_PE2_fixed.fq" -o $BASENAME.kaiju
done

conda deactivate kaiju


