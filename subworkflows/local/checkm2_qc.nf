/*
 * CheckM2: Assessing the quality of metagenome-derived genome bins using machine learning
 */

include { CHECKM2_PREDICT } from '../../modules/nf-core/checkm2/predict/main'

workflow CHECKM_QC {
    take:
    bins       // channel: [ val(meta), path(bin) ]
    checkm2_db

    main:
    ch_versions = Channel.empty()

    CHECKM2_PREDICT ( bins, checkm_db )
    ch_versions = ch_versions.mix(CHECKM2_PREDICT.out.versions.first())

    COMBINE_CHECKM_TSV ( CHECKM_QA.out.output.map{it[1]}.collect() )

    emit:
    summary     = CHECKM2_PREDICT.out.checkm2_tsv
    versions    = ch_versions
}