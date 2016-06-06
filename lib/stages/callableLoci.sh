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

callableLoci () {
    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
	        callableLociRun "$1";
		 ;;
	    depend) dependCallableLoci;
		    ;;
	    *) echo "ERROR. run as: callableLoci depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
}


#Run program
callableLociRun () {
    if [ ! -d "CallableLoci" ]; then
	mkdir CallableLoci
    fi

    file=$1
    out=$(basename "$file")
    $GATK -T CallableLoci -R $REF \
	-I $file \
	-L $bed \
	-summary CallableLoci/$out.txt \
	-o CallableLoci/$out.status.bed

}
