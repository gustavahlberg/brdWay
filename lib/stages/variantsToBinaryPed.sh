#!/bin/bash
#
# Author: Gustav 
# variantsToBinaryPed stage
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

variantsToBinaryPed () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		variantsToBinaryPedRun "$1";
		 ;;
	    depend) shift
		    dependVariantsToBinaryPed "$1";
		    ;;
	    *) echo "ERROR. run as: variantsToBinaryPed depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run variantsToBinaryPed
variantsToBinaryPedRun () {
    IN=$1
    output $1
    OUTPUT=${OUTPUT:-${OUT%.vcf}}

    $GATK -T VariantsToBinaryPed -R $REF \
	-V $IN \
	-m $META \
	-bed $OUTPATH$OUTPUT.bed \
	-bim $OUTPATH$OUTPUT.bim \
	-fam $OUTPATH$OUTPUT.fam \
	-mgq $MPG \
	-l DEBUG \
	--majorAlleleFirst

    echo "variantsToBinaryPed run exit status $?"	
}
