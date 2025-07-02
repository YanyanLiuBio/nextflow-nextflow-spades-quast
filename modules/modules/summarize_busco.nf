process SUMMARIZE_BUSCO {
 // publishDir path: "busco_summary", pattern: '*.csv', mode: 'copy'
  publishDir path: "s3://${params.s3_path}/${params.run}/${params.analysis}/", pattern: '*.csv', mode: 'copy'

  input:
  path(quast_reports)

  output:
  path("*")

  script:

  """  
  bash summarize_busco.sh  ${params.run}_${params.analysis}  
    
  """
}


