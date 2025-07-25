#!/bin/sh
# requirements in paths: sra-tools, seqyclean, sortmerna, BBmap, kaiju

mkdir wd_dir
cd wd_dir

mkdir srtRNA_wd_tmp

cat ../$1 | while read line; do 
    fasterq-dump $line 
    seqyclean -1 "${line}_1.fastq" -2 "${line}_2.fastq" -qual -o $line -c /home/riwama/databases/univec/univec.fasta
    sortmerna -ref ~/databases/sortmerna_db/smr_v4.3_default_db.fasta -reads "${line}_PE1.fastq" -reads "${line}_PE2.fastq" -a 16 -other $line -out2 -fastx -workdir srtRNA_wd_tmp
    repair.sh in1="${line}+" in2="${line}_rev.fq" out1="${line}_fwd_fixed.fastq" out2="${line}_rev_fixed.fastq"
    kaiju -E 10-5 -v -z 16 -t ~/databases/kaijudb/nodes.dmp -f ~/databases/kaijudb/viruses/kaiju_db_viruses.fmi -i "${line}_fwd_fixed.fastq" -j "${line}_rev_fixed.fastq" -o ../$line.kaiju
    cd ..
    rm -rf wd_dir
done

