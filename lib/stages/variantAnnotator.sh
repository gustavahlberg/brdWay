#!/bin/bash
#
# Author: Gustav 
# 
#-----------------------------------------
#
#source configurations
#

STAGEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $STAGEDIR/../../configDir/config.sh
. $STAGEDIR/../../lib/dependCheck.sh
PWD=`pwd`
PWD=${PWD%/}
: ${outdir:=$PWD}

#-----------------------------------------
# Function: variantsEval
# Runs GATK variant Annotator
#

variantAnnotator () {
    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 variantAnnotatorRun "$1";
		 ;;
	    depend) dependVariantAnnotator;
		    ;;
	    *) echo "ERROR. run as: variantAnnotator depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run program
variantAnnotatorRun () {
    
    if [[ $# -ge 1 ]]; then
	#then
	output $1
	echo $OUT
	
	$GATK -R $REF -T VariantAnnotator \
	    
	-comp $exac \
	-eval $1 \
	-o $OUT.eval.gatkreport \
	-L $bed \
        -ip $PADDING \
	-nt $nt
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantEval run exit status $?"	


}

