process SUMMARIZE_BUSCO {


  input:
  path(quast_reports)

  output:
  path("*")

  script:

  """  
  bash summarize_busco.sh  ${params.run}_${params.analysis}
    
  """
}

