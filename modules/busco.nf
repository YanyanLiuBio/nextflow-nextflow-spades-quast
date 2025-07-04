BUSCO {
    tag "$sample_ID"
    // publishDir path: "busco", mode: 'copy'
    publishDir path: "s3://${params.s3_path}/${params.run}/${params.analysis}/BUSCO", pattern: '*busco.txt', mode: 'copy'
    
    input:
    tuple  val(sample_ID), path(fa), path(ref)
    
    output:
    path("*busco"), emit: busco_results
    path("*busco.txt"), emit: busco_report
    
    script:
    """
    ref_basename=\$(basename ${ref} | cut -d'.' -f1)
    
    # Determine most specific BUSCO lineage
    case "\$ref_basename" in
        "Bacillus_cereus"|"Bacillus_subtilis")
            busco_lineage="bacillales_odb10"
            ;;
        "Clostridioides_difficile")
            busco_lineage="clostridia_odb10"
            ;;
        "Enterobacter_cloacae")
            busco_lineage="enterobacterales_odb10"
            ;;
        "Escherichia_coli-K12_ATCC"|"Ecoli"*)
            busco_lineage="enterobacterales_odb10"
            ;;
        "Pseudomonas_aeruginosa")
            busco_lineage="gammaproteobacteria_odb10"
            ;;
        "Rhodobacter_sphaeroides")
            busco_lineage="alphaproteobacteria_odb10"
            ;;
        "Saccharomyces_cerevisiae")
            busco_lineage="saccharomycetes_odb10" 
            ;;
        "Staphylococcus_epidermidis")
            busco_lineage="bacillales_odb10"
            ;;
        "Shigella"*)
            busco_lineage="enterobacterales_odb10"
            ;;
        "Salmonella"*)
            busco_lineage="enterobacterales_odb10"
            ;;
        *)
    esac
    
    busco -i ${fa} -l \$busco_lineage -o ${sample_ID}_busco -m genome --cpu ${task.cpus}
    
    cp ${sample_ID}_busco/*.txt  .
    
    """
}
