process DOWNSAMPLE {

    publishDir path: "s3://seqwell-fastq/${params.run}/${params.analysis}/", pattern: '*.fastq.gz', mode: 'copy'
  
//    publishDir path: "s3://seqwell-analysis/${params.run}/${params.analysis}/DOWNSAMPLE", pattern: '!(*full*)_R*_001.fastq.gz', mode: 'copy'

    tag "${pair_id}_${downsample_depth}"

    input:
    tuple val(well), val(pair_id), path(read1), path(read2), val(downsample_depth), path(ref)

    output:
    tuple val(well), val("${pair_id}.${downsample_depth > 0 ? downsample_depth : 'full'}"), path('*_R1_001.fastq.gz'), path('*_R2_001.fastq.gz'), path(ref)


    script:
    def ds_label = downsample_depth > 0 ? downsample_depth : 'full'
    def basename = "${pair_id}.${ds_label}"
    

    """
    if [ ${downsample_depth} -gt 0 ]; then
        seqtk sample -s 14 ${read1} ${downsample_depth} | gzip > ${basename}_R1_001.fastq.gz
        seqtk sample -s 14 ${read2} ${downsample_depth} | gzip > ${basename}_R2_001.fastq.gz
    else
        ln -s ${read1} ${basename}_R1_001.fastq.gz
        ln -s ${read2} ${basename}_R2_001.fastq.gz
    fi
    """
    
}

