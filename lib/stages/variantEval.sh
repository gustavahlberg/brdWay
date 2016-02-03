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
# Runs GATK variant evaluation
#

variantEval () {
    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 variantEvalRun "$1";
		 ;;
	    depend) dependVariantEval;
		    ;;
	    *) echo "ERROR. run as: variantEval depend/run ";
	       echo "HEJ"
	       #exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run program
variantEvalRun () {
    
    if [[ $# -ge 1 ]]; then
	#then
	output
	
	$GATK -R $REF -T VariantEval \
        -D $dbsnp \
	-comp $exac \
	-eval $1 \
	-o $OUT.eval.gatkreport\
	-L $bed\
        -ip $PADDING
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantEval run exit status $?"	


}

