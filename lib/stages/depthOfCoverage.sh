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
# Runs bedtools histograms
#

depthOfCoverage () {
    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
	        depthOfCoverageRun "$1";
		 ;;
	    depend) dependDepthOfCoverage;
		    ;;
	    *) echo "ERROR. run as: depthOfCoverage depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
}


#Run program
depthOfCoverageRun () {
    list=$1
   
    $GATK -T DepthOfCoverage -R $REF \
	-o $OUTPATH$OUTPUT \
	-I $list \
	-L $bed
}
