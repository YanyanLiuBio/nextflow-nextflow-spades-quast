#!/usr/bin/env bash

# Converts multiple BUSCO short summary files into a combined CSV with full column names
# Usage: bin/busco_batch_to_csv.sh short_summary*.txt > combined_busco_summary.csv

set -euo pipefail

analysis_info=$1
output=${analysis_info}"busco_summary.csv"

# Print CSV header
echo "lineage,sample_ID,Complete_Percent,Single_Copy_Percent,Duplicated_Percent,Fragmented_Percent,Missing_Percent,Total_BUSCOs,Complete_Count,Single_Copy_Count,Duplicated_Count,Fragmented_Count,Missing_Count,Total_Searched,Num_Scaffolds,Num_Contigs,Total_Length,Percent_Gaps,Scaffold_N50,Contig_N50" >>  $output

ls | grep busco.txt > file_list
# Loop through input files
while read input_file ; do

    lineage=$(basename "$input_file" | sed -E 's/short_summary\.specific\.([^.]+)\..*/\1/')
    # Extract sample ID (last dot-separated field before _busco.txt)
    sample_id=$(basename "$input_file" | sed -E 's/.*\.([^.]+)_busco\.txt/\1/')

    complete_pct=$(grep -Po 'C:\K[0-9.]+' "$input_file")
    single_pct=$(grep -Po 'S:\K[0-9.]+' "$input_file")
    duplicated_pct=$(grep -Po 'D:\K[0-9.]+' "$input_file")
    fragmented_pct=$(grep -Po 'F:\K[0-9.]+' "$input_file")
    missing_pct=$(grep -Po 'M:\K[0-9.]+' "$input_file")
    total_buscos=$(grep -Po 'n:\K[0-9]+' "$input_file")

    complete_count=$(grep "Complete BUSCOs" "$input_file" | awk '{print $1}')
    single_count=$(grep "single-copy BUSCOs" "$input_file" | awk '{print $1}')
    duplicated_count=$(grep "duplicated BUSCOs" "$input_file" | awk '{print $1}')
    fragmented_count=$(grep "Fragmented BUSCOs" "$input_file" | awk '{print $1}')
    missing_count=$(grep "Missing BUSCOs" "$input_file" | awk '{print $1}')
    searched_count=$(grep "Total BUSCO groups searched" "$input_file" | awk '{print $1}')

    scaffolds=$(grep "Number of scaffolds" "$input_file" | awk '{print $1}')
    contigs=$(grep "Number of contigs" "$input_file" | awk '{print $1}')
    total_length=$(grep "Total length" "$input_file" | awk '{print $1}')
    percent_gaps=$(grep "Percent gaps" "$input_file" | awk '{print $1}' | tr -d '%')
    scaffold_n50=$(grep "Scaffold N50" "$input_file" | awk '{print $1}' | sed 's/ KB//')000
    contig_n50=$(grep "Contigs N50" "$input_file" | awk '{print $1}' | sed 's/ KB//')000

    echo "$lineage, $sample_id,$complete_pct,$single_pct,$duplicated_pct,$fragmented_pct,$missing_pct,$total_buscos,$complete_count,$single_count,$duplicated_count,$fragmented_count,$missing_count,$searched_count,$scaffolds,$contigs,$total_length,$percent_gaps,$scaffold_n50,$contig_n50" >> $output
done < file_list

