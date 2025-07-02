process SPADES {
  
  errorStrategy 'ignore'  
  publishDir path: "s3://${params.s3_path}/${params.run}/${params.analysis}/SPADES", pattern: '*_spades_out', mode: 'copy'
  
  
  input:
  tuple  val(sample_ID),  path( fq1), path( fq2), path(ref)
  
  output:
  path( "*"), emit: spades_out
  tuple  val(sample_ID), path("*.contigs.fasta"), path(ref), emit: fa
  
  """
   spades.py  -1 $fq1 -2 $fq2 -o ${sample_ID}_spades_out   --threads  ${task.cpus}
   cp ${sample_ID}_spades_out/contigs.fasta ${sample_ID}.contigs.fasta
  
  """
}
