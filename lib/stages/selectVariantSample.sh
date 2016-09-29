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
# Remove samples from a vcf
#

selectVariantSample () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 selectVariantSampleRun "$@";
		 ;;
	    depend) shift
		    dependSelectVariantSample "$@";
		    ;;
	    *) echo "ERROR. run as: selectVariantsRemoveSample depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run selectVariants
selectVariantSampleRun () {

    if [[ $# -ge 1 ]]; then
	vcf=$1
	output $vcf
	OUT=${OUT%.vcf}.selectedSamples.vcf
	OUTPUT=${OUTPUT:=$OUT}
	
	#default cores 1
	: ${NT:=1}
	#in=$(basename $vcf)
	#out=${in%.*}.selectSamples.vcf

	$GATK -R $REF -T SelectVariants -V $vcf \
	      -o $OUTPUT \
	      -nt $NT \
	      --sample_file $LIST
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantToTable run exit status $?"	

}

