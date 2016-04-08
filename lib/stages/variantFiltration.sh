?#!/bin/bash
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

variantFiltration () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		variantFiltrationRun "$1";
		 ;;
	    depend) shift
		    dependvariantFiltration "$1";
		    ;;
	    *) echo "ERROR. run as: variantFiltration depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run selectVariants
variantFiltrationRun () {
    if [[ $# -ge 1 ]]; then
	vcf=$1
	output $vcf
	echo $filterExpression
	OUT=${OUT%.vcf}.$HARDFILTER.vcf
	$GATK -T VariantFiltration -R $REF -V $vcf \
	--filterExpression "$filterExpression" \
        --filterName $HARDFILTER \
	-o $OUT
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantFiltration run exit status $?"	

}
