---
output:
  word_document: default
  html_document: default
---
# bacteria spades assembly
by Yanyan Liu


## what for
This is the nextflow pipeline that does bacteria genome assembly using spades. 
The assembly metrics are collected by QUAST. BUSCO metrics is also produced.
It is currently does not have the downsample option.

## how to run
### 1.copy the code below to nextflow_spades.sh

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


### 2.run as *bash nextflow_spades.sh*

### 3.sample map example and requirement
```
sample_id,ref
Ecoli_Std_A04,Ecoli_SAMN07731009_gcf
Ecoli_Std_B04,Ecoli_SAMN07731009_gcf
Ecoli_Std_C04,Ecoli_SAMN07731009_gcf
Ecoli_Std_D04,Ecoli_SAMN07731009_gcf
Ecoli_Std_E04,Ecoli_SAMN07731009_gcf
Ecoli_Std_F04,Ecoli_SAMN07731009_gcf
Ecoli_Std_G04,Ecoli_SAMN07731009_gcf
Ecoli_Std_H04,Ecoli_SAMN07731009_gcf
```

- The sample map needs two columns, with the right header: *sample_id* and *ref*
- For sample_id, it needs to be matched to the fastq file names. For example, if the fastq file is Ecoli_HS_H07_R1_001.fastq.gz and Ecoli_HS_H07_R2_001.fastq.gz. The sample_id will be *Ecoli_HS_H07*