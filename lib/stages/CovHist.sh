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

covHist () {
    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 covHistRun "$1";
		 ;;
	    depend) dependCovHist;
		    ;;
	    *) echo "ERROR. run as: covHist depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
}


#Run program
covHistRun () {
    mkdir hist_cov
    module load bedtools
    file=$1
    out=$(basename "$file")
    hist="hist_cov/"$out".hist.all.txt"
    echo "bedfile used $bed"
    echo $file
    bedtools coverage -hist -abam $file -b $bed  | grep ^all > $hist 
}
