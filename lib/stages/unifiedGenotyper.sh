#!/bin/bash
#
# Author: Gustav 
# UnifiedGenotyper stage
# supply input as a list
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

unifiedGenotyper () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		unifiedGenotyperRun "$1";
		 ;;
	    depend) shift
		    dependUnifiedGenotyper "$1";
		    ;;
	    *) echo "ERROR. run as: unifiedGenotyper depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run unifiedGenoTyper
unifiedGenotyperRun () {
    list=$1

    $GATK -T UnifiedGenotyper -R $REF \
    -I $list \
    -glm $TYPE \
    --dbsnp $dbsnp \
    -o $OUTPATH$OUTPUT \
    -L $bed \
    --interval_padding $PADDING \
    -stand_call_conf 30.0 \
    -stand_emit_conf 10.0 \
    -nt $nt
    
    echo "unifiedGenotyper run exit status $?"	
}
