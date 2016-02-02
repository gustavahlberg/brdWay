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
# Function: variantsToTables
# Creates a table of a vcf using gatk varintsToTables
#

# create vcf specific option string
infoString() {
    head -1000 $1 | grep '#' > header
    grep 'INFO=<' header > info
    COL=`cat info | perl -ane 'chomp;$_=~m/##INFO=<ID=([^,]*)/;print " -F $1"'`
    echo ${COL%" "}
    rm info header
}


#parse function variantsToTable
variantsToTable () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 variantsToTableRun "$@";
		 ;;
	    depend) dependVariantsToTable;
		    ;;
	    *) echo "ERROR. run as: variantsToTable depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run variants to table
variantsToTableRun () {

    if [[ $# -ge 1 ]]; then
	#then	
	COLUMNS=`infoString $1`

	$GATK -R $REF -T VariantsToTable -V $1 \
	--showFiltered --allowMissingData \
	-o $1.table \
	-F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F FILTER \
	$COLUMNS \
	-GF GT -GF AD -GF DP -GF GQ -GF PL
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantToTable run exit status $?"	

}

