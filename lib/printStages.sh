#!/bin/bash

#print all available stages


printStages () {
    echo "variantsToTable: ....."
    echo "selectVariantRegion: arg1= vcf ,arg2= bed, arg3= no cores"
    echo "selectVariantSample":
    echo "selectVariantsRemoveSample":
    echo "variantEval: run GATK variantEval"
    echo "covHist: makes coverage histograms tables with bedtools"
    echo "callableLoci: run GATK callable loci"
    echo "applyRecalibration: run GATK ApplyRecalibration"
    echo "variantRecalibrator: run GATK VariantRecalibrator"
    echo "cutNtrim: run cutadapt and prinseq-lite"
    echo "alignBwa: Runs bwa, then samttols sort and samtools index"
    echo "unifiedGenotyper: Runs GATK UnifiedGenotyper, supply input (-i) bams as a list"
    echo "indelReAln: Runs GATK RealignerTargetCreator and IndelRealigner. Default both set to TRUE"
    echo "bqsr: BaseRecalibrator, PrintReads, BaseRecalibrator, AnalyzeCovariates. Default all set to TRUE"
    exit 0
}
