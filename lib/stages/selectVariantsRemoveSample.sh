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

selectVariantsRemoveSample () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 selectVariantsRemoveSampleRun "$@";
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
selectVariantsRemoveSampleRun () {

    if [[ $# -ge 1 ]]; then
	vcf=$1
	#default cores 1
	: ${NT:=1}
	in=$(basename $vcf)
	out=${in%.*}.selectSamples.vcf

	$GATK -R $REF -T SelectVariants -V $vcf\
	-o $outdir/$out\
	-nt $NT\
	--exclude_sample_file  $LIST
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantToTable run exit status $?"	

}

