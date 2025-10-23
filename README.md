





This document describes the pepiline for virome reconstruction from NCBI SRA RNA-seq data.
For most of the transcriptomes, viromes were reconstructed based on the script ```GetVirome.sh```.

Code for GetVirome.sh:

```
#!/bin/sh
# requirements in paths: sra-tools, seqyclean, sortmerna, BBmap, kaiju

A=$(pwd)

cat $1 | while read line; do
    mkdir wd_dir
    cd wd_dir
    mkdir srtRNA_wd_tmp
    fasterq-dump $line -e 30
    seqyclean -1 "${line}_1.fastq" -2 "${line}_2.fastq" -qual -o $line -c /home/riwama/databases/univec/univec.fasta -minlen 50
    echo "seqyclean done"
    sortmerna -ref ~/databases/sortmerna_db/smr_v4.3_default_db.fasta -reads "${line}_PE1.fastq" -reads "${line}_PE2.fastq" -a 30 -other ./$line -out2 -fastx -workdir srtRNA_wd_tmp
    echo "sortmerna done"
    repair.sh in1="${line}_fwd.fq" in2="${line}_rev.fq" out1="${line}_fwd_fixed.fastq" out2="${line}_rev_fixed.fastq"
    echo "repair done"
    kaiju -E 10-5 -v -z 30 -t ~/databases/kaijudb/nodes.dmp -f ~/databases/kaijudb/viruses/kaiju_db_viruses.fmi -i "${line}_fwd_fixed.fastq" -j "${line}_rev_fixed.fastq" -o ../$line.kaiju
    echo "kaiju done"
    cd $A
    rm -rf wd_dir
    echo "Processing of $line completed."

done

```

This script is used for paired ended data.


For single reads:

```
seqyclean -U SRR14872363.fastq -qual -o SRR14872363 -c /home/riwama/databases/univec/univec.fasta -minlen  50
sortmerna -ref ~/databases/sortmerna_db/smr_v4.3_default_db.fasta -reads SRR14872363_SE.fastq -a 8 -other ~/Cracas_viroma/seqyclean_done/sort_wd/out/SRR14872363 -fastx -workdir ~/Cracas_viroma/seqyclean_done/sort_wd
kaiju -E 10-5 -v -z 1 -t ~/databases/kaijudb/nodes.dmp -f ~/databases/kaijudb/viruses/kaiju_db_viruses.fmi -i SRR14872363.fq -o ~/Cracas_viroma/kaiju_done/SRR14872363.kaiju

```


Taxon names were added with the following command

```
kaiju-addTaxonNames -t nodes.dmp -n names.dmp -i kaiju.out -o kaiju.names.out -r superkingdom,phylum,class,order,family,genus,species
```

Kaiju files were converted to csv files to be read into dataframes by pandas on python. Linnea rank used: Genus


```
python3 KaijuToDf.py nodes.dmp names.dmp NCBI_runinfo.txt genus
```


