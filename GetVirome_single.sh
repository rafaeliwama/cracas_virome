#!/bin/sh
# requirements in paths: sra-tools, seqyclean, sortmerna, BBmap, kaiju

A=$(pwd)

cat $1 | while read line; do
    mkdir wd_dir
    cd wd_dir
    mkdir srtRNA_wd_tmp
    
    fasterq-dump $line -e 30

    seqyclean -U "${line}.fastq" -qual -o $line -c virome_databases/univec.fasta -minlen 50    
    echo "seqyclean done"

    sortmerna -ref virome_databases/smr_v4.3_default_db.fasta -reads "${line}_SE.fastq" -a 30 -other ./$line -fastx -workdir srtRNA_wd_tmp
    echo "sortmerna done"

    kaiju -E 10-5 -v -z 30 -t ~/databases/kaijudb/nodes.dmp -f ~/databases/kaijudb/viruses/kaiju_db_viruses.fmi -i "${line}.fq" -o ../$line.kaiju
    echo "kaiju done"

    cd $A
    rm -rf wd_dir
    echo "Processing of $line completed."

done
