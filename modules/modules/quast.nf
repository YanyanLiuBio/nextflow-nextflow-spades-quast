process QUAST {

  publishDir path: "s3://${params.s3_path}/${params.run}/${params.analysis}/QUAST", pattern: '*_quast_output', mode: 'copy'

  input:
  tuple  val(sample_ID), path(fa), path(ref)
  

  output:
  path("*_quast_output"), emit: quast_out
  path("*.tsv"), emit: report

  script:
  def ref_cmd = ref ? "--reference ${ref}" : ""
  """
  quast.py -o ${sample_ID}_quast_output $fa $ref_cmd
  mv ${sample_ID}_quast_output/report.tsv ${sample_ID}.report.tsv
  """
}
