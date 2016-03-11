#!/bin/bash

#print all available stages


printStages () {
    echo "variantsToTable: ....."
    echo "selectVariantRegion: arg1= vcf ,arg2= bed, arg3= no cores"
    echo "selectVariantsSample":
    echo "selectVariantsRemoveSample":
    echo "variantEval"
    echo "covHist: makes coverage histograms tables with bedtools"
    echo "callableLoci: run GATK callable loci"
    exit 0
}
