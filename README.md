# bacteria spades assembly
by Yanyan Liu


## what for
This is the nextflow pipeline that does bacteria genome assembly using spades. 
The assembly metrics are collected by QUAST. BUSCO metrics is also produced.
It is currently does not have the downsample option.

## how to run
1.copy the code below to nextflow_spades.sh

```
#!/bin/bash

run=20250627_NextSeq2000
plates=Ecoli_*_FASTQ
sample_map=ecoli_samples_map.csv
analysis=Ecoli_spades_busco



/software/nextflow-align/nextflow run \
/software/nextflow-spades-quast/main.nf \
-work-dir  s3://seqwell-analysis/${run}/${analysis}/work \
--analysis $analysis \
--run $run \
--plates $plates \
--sample_map $sample_map \
-bg -resume


```


2. run as *bash nextflow_spades.sh*