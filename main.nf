#!/usr/bin/env nextflow

include { DOWNSAMPLE } from './modules/downsample.nf'
include { SPADES } from './modules/spades.nf'
include { QUAST } from './modules/quast.nf'
include { SUMMARIZE_QUAST } from './modules/summarize_quast.nf'
include { BBREPAIR } from './modules/bbrepair.nf'
include { FASTP } from './modules/fastp.nf'
include { BUSCO } from './modules/busco.nf'
include { SUMMARIZE_BUSCO } from './modules/summarize_busco.nf'



workflow {

    // ==== 1. Ensure sample_map param is provided ====
    if ( !params.sample_map ) {
        error "Missing required parameter: --sample_map"
    }

    // ==== 2. Load FASTQ pairs with (sample_id, fq1, fq2) ====
    fq = Channel.fromFilePairs(
        "s3://seqwell-fastq/${params.run}/{${params.plates}}/*_R{1,2}_001.fastq.gz", 
        flat: true,
        checkIfExists: true
    )
    .take(params.dev ? params.number_of_inputs : -1)
     
     //fq.view()

     fq.collect().view { it.size() }

   fastp_fq = FASTP(fq)
   bbrepair_fq = BBREPAIR(fastp_fq)

    // ==== 3. Load downsample_map as (sample_id, ref) ====
    meta = Channel
        .fromPath(params.sample_map)
        .splitCsv(header: true)
        .map { row -> 
            well = row.sample_id
            ref_raw = row.ref ?: ""
            ref_path = ref_raw ? "s3://seqwell-ref/${ref_raw}.fa" : ""
            [ well, ref_path ] 
        }
    //meta.view()
    meta.collect().view { it.size() }

    // ==== 4. Join FASTQ with metadata → (sample_id, fq1, fq2, depth, ref_path) ====
    fq_with_meta = bbrepair_fq.join(meta, by: 0)
                   
    //fq_with_meta.view()
  
    // ==== 6. Run SPADES ====
    assembled = SPADES( fq_with_meta )

    // ==== 7. Run QUAST ====
     QUAST(assembled.fa)

    // ==== 8. Summarize QUAST ====
    SUMMARIZE_QUAST(QUAST.out.report.collect())


    // ==== 9. Run  BUSCO ====
    BUSCO(assembled.fa)

    // ==== 10. Summarize  BUSCO ====
    SUMMARIZE_BUSCO(BUSCO.out.busco_report.collect())

    // ==== 11. Workflow event handlers ====
    workflow.onComplete = {
        println "Pipeline completed at: $workflow.complete"
        println "Pipeline completed time duration: $workflow.duration"
        println "Command line: $workflow.commandLine"
        println "Execution status: ${workflow.success ? 'OK' : 'failed'}"
    }

    workflow.onError = {
        println "Error: Pipeline execution stopped with the following message: ${workflow.errorMessage}"
    }

}

