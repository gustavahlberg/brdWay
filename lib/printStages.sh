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
    echo "variantRecalibrattor: run GATK VariantRecalibrator"
    exit 0
}
