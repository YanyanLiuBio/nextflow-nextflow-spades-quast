process BUSCO {
    tag "$sample_ID"
    publishDir path: "busco", mode: 'copy'
    
    
    input:
    tuple val(well), val(sample_ID), path(fa), path(ref)
    
    output:
    path("*busco"), emit: busco_results
    path("*busco.txt"), emit: busco_report
    
    script:
    """
    ref_basename=\$(basename ${ref} | cut -d'.' -f1)
    
    # Determine most specific BUSCO lineage
    case "\$ref_basename" in
        "Saccharomyces_cerevisiae")
            busco_lineage="fungi_odb10"
            ;;
        "Escherichia_coli"|"Klebsiella"*|"Ecoli"*|"Salmonella"*|"Enterobacter"*|"Shigella"*)
            busco_lineage="enterobacterales_odb10"
            ;;
        "Pseudomonas"*)
            busco_lineage="pseudomonadales_odb10"
            ;;
        "Staphylococcus"*)
            busco_lineage="bacillales_odb10"
            ;;
        "Streptococcus"*|"Lactobacillus"*)
            busco_lineage="lactobacillales_odb10"
            ;;
        "Mycobacterium"*)
            busco_lineage="actinobacteria_odb10"
            ;;
        *)
            # Fallback to broad bacterial lineage
            busco_lineage="bacteria_odb10"
            ;;
    esac
    
    busco -i ${fa} -l \$busco_lineage -o ${sample_ID}_busco -m genome --cpu ${task.cpus}
    
    cp ${sample_ID}_busco/*.txt  .
    
    """
}