# bacteria spades assembly
by Yanyan Liu


## what for
This is the nextflow pipeline that does bacteria genome assembly using spades. 
The assembly metrics are collected by QUAST.

## how to run
1.copy the code below to nextflow_spades.sh

```
#!/bin/bash

run=20250115_NextSeq2000
plates=C1003_clean_FASTQ


/software/nextflow-align/nextflow run 
/software/nextflow-spades-quast/main.nf \
-work-dir s3://seqwell-analysis/${run}/work/ \
--run $run \
--plates $plates \
-bg -resume

```


2. run as *bash nextflow_spades.sh*