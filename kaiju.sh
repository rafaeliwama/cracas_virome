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

repair.sh in1=~/Cracas_viroma/sortmerna_done/ in2=~/Cracas_viroma/sortmerna_done/*.PE2_Ced.fastq out1=~/Cracas_viroma/sortmerna_done/paired.PE1_Ced.fastq out2=~/Cracas_viroma/sortmerna_done/paired.PE2_Ced.fastq