process SUMMARIZE_QUAST {

  publishDir path: "s3://${params.s3_path}/${params.run}/${params.analysis}/", pattern: '*.csv', mode: 'copy'

  input:
  path(quast_reports)

  output:
  path("*")

  script:
   

    """  
    
    output="quast_summary_${params.run}_${params.analysis}.csv"

  # Write header to CSV file
  echo "Sample,Num_Contigs,Reference_Length,Reference_GC,N50,Genome_Fraction" > \$output

  # Loop through all report.tsv files
  for report in \$(find ${quast_reports} -name '*.report.tsv'); do
      sample=\$(basename "\$report" | sed -E 's/\\.report\\.tsv\$//')

      num_contigs=\$(awk -F'\t' '\$1 ~ /^# contigs\$/ {gsub(/^[ \\t]+|[ \\t]+\$/, "", \$2); print \$2}' "\$report")
      ref_length=\$(awk -F'\t' '\$1 ~ /^Reference length\$/ {gsub(/^[ \\t]+|[ \\t]+\$/, "", \$2); print \$2}' "\$report")
      ref_gc=\$(awk -F'\t' '\$1 ~ /^Reference GC/ {gsub(/^[ \\t]+|[ \\t]+\$/, "", \$2); print \$2}' "\$report")
      n50=\$(awk -F'\t' '\$1 ~ /^N50\$/ {gsub(/^[ \\t]+|[ \\t]+\$/, "", \$2); print \$2}' "\$report")
      genome_frac=\$(awk -F'\t' '\$1 ~ /^Genome fraction/ {gsub(/^[ \\t]+|[ \\t]+\$/, "", \$2); print \$2}' "\$report")

      echo "\${sample},\${num_contigs},\${ref_length},\${ref_gc},\${n50},\${genome_frac}" >> \$output
  done
    
    
  """
}

