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

#echo $PWD
#echo $outdir
#-----------------------------------------
#
# select variant in region defined by bed file
#

selectVariantRegion () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 selectVariantRegionRun "$@";
		 ;;
	    depend) shift
		    dependSelectVariantRegion "$@";
		    ;;
	    *) echo "ERROR. run as: variantsToTable depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run selectVariants
selectVariantRegionRun () {

    if [[ $# -ge 1 ]]; then
	#then
	vcf=$1
	#default cores 4
	NT=${NT:-4}
	output $vcf
	OUT=${OUT%.vcf}.selectRegion.vcf
	OUTPUT=${OUTPUT:-$OUT}

	$GATK -R $REF -T SelectVariants -V $vcf \
	-L $bed \
	-o $OUTPATH$OUTPUT \
	-nt $NT \
	-selectType INDEL -selectType SNP \
	--interval_padding $PADDING
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantToTable run exit status $?"	

}

