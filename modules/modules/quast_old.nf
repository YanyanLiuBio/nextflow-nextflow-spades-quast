process QUAST { 
  errorStrategy 'ignore'  
  publishDir path: "s3://seqwell-analysis/${params.run}/${params.analysis}/QUAST", pattern: '*_quast_output', mode: 'copy'
  
  input:
  tuple val(sample_ID), path (fa) 
  
  output:
  path("*_quast_output"), emit: quast_out
  path("*.tsv"), emit: report
  
 """
 quast.py -o ${sample_ID}_quast_output $fa
 mv ${sample_ID}_quast_output/report.tsv  ${sample_ID}.report.tsv
 """

}
