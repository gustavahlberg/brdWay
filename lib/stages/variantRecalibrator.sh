#!/bin/bash
#
# Author: Gustav 
# 
#
#
#-----------------------------------------
#source configurations

STAGEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $STAGEDIR/../../configDir/config.sh
. $STAGEDIR/../../lib/dependCheck.sh
PWD=`pwd`
PWD=${PWD%/}
: ${outdir:=$PWD}


#-----------------------------------------
#
# Split a vcf after typ e.g. SNP or INDEL
#

variantRecalibrator () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		variantRecalibratorRun "$1";
		 ;;
	    depend) shift
		    dependvariantRecalibrator "$1";
		    ;;
	    *) echo "ERROR. run as: variantRecalibrator depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run variantRecalibrator
variantRecalibratorRun () {
    vcf=$1
    echo "Hej"
    case $TYPE in 
	SNP) shift 
	    variantRecalibratorRunSNP "$vcf";
	    ;;
	INDEL) shift	
	    variantRecalibratorRunINDEL "$vcf";
	    ;;
	*) echo "ERROR. set TYPE var to \"SNP\" or \"INDEL\"";
	    exit 1
	    ;;
    esac
	     
}
    


#============================================================
# variantRcalibrator for SNPs
#============================================================

variantRecalibratorRunSNP () {
    if [[ $# -ge 1 ]]; then
	vcf=$1
	output $vcf
	echo $filterExpression
	OUT=${OUT%.gz}
	OUT=${OUT%.vcf}
	OUTPUT=${OUTPUT:-$OUT}
	echo $ANNOTATIONS_SNPS

	$GATK -T VariantRecalibrator -R $REF \
	-input $vcf \
	-resource:hapmap,known=false,training=true,truth=true,prior=15.0 $HAPMAP \
	-resource:omni,known=false,training=true,truth=true,prior=12.0 $OMNI \
	-resource:1000G,known=false,training=true,truth=false,prior=10.0 $G1K \
	-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $dbsnp \
	$ANNOTATIONS_SNPS \
	-mode $TYPE \
	-tranche 100.0 -tranche 99.9 -tranche 99.5 -tranche 99.0 -tranche 90.0 \
	-recalFile $OUTPUT.recalibrate_SNP.recal \
	-tranchesFile $OUTPUT.recalibrate_SNP.tranches \
	-rscriptFile $OUTPUT.recalibrate_SNP_plots.R \
	-nt $nt
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantRecalibratorRunSNP run exit status $?"	

}




#============================================================
# variantRecalibrator for INDELs
#============================================================

variantRecalibratorRunINDEL () {
    if [[ $# -ge 1 ]]; then
	vcf=$1
	output $vcf
	echo $filterExpression
	OUT=${OUT%.gz}
	OUT=${OUT%.vcf}
	OUTPUT=${OUTPUT:-$OUT}
	nt=${nt:-1}


	$GATK -T VariantRecalibrator -R $REF \
	    -input $vcf \
	    -resource:mills,known=true,training=true,truth=true,prior=12.0 $MILLS \
	    $ANNOTATIONS_INDELS \
	    -mode $TYPE \
	    -tranche 100.0 -tranche 99.9 -tranche 99.5 -tranche 99.0 -tranche 90.0 \
	    --maxGaussians 4 \
	    -recalFile $OUTPUT.recalibrate_INDEL.recal \
	    -tranchesFile $OUTPUT.recalibrate_INDEL.tranches \
	    -rscriptFile $OUTPUT.recalibrate_INDEL_plots.R \
	    -nt $nt


    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantRecalibratorRunINDEL run exit status $?"	

}




