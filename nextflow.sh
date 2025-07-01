#!/bin/bash

run=20250516_Admera_Health
plates=downsample100x_MWGS_FASTQ
downsample_map=spade_map_100x.csv
analysis=100xspades
dev=true
number_of_inputs=200


/software/nextflow-align/nextflow run main.nf \
-work-dir s3://seqwell-users/yanyan/quast_admera/work \
-c nextflow.config \
--analysis $analysis \
--run $run \
--plates $plates \
--downsample_map $downsample_map \
--dev $dev \
--number_of_inputs $number_of_inputs \
-bg -resume


