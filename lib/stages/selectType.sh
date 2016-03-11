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
# Split a vcf after typ e.g. SNP or INDEL
#

selectType () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 selectTypeRun "$1";
		 ;;
	    depend) shift
		    dependSelectType "$1";
		    ;;
	    *) echo "ERROR. run as: selectType depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run selectVariants
selectTypeRun () {

    if [[ $# -ge 1 ]]; then
	vcf=$1
	output $vcf
	OUT=${OUT%.vcf}.$TYPE.vcf
	$GATK -T SelectVariants -R $REF -V $vcf \
	-selectType $TYPE -o $OUT
    else
	echo "ERROR: No input file supplied"
    fi
    echo "selectType run exit status $?"	

}

