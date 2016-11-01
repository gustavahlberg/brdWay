#!/bin/bash
#
# Author: Gustav 
# combineGvcfs. Give input as i names.list 
# manually set outout with $OUT=<out> brdway.sh
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

combineGvcfs () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 combineGvcfsRun "$1";
		 ;;
	    depend) shift
		    dependCombineGvcfs "$1";
		    ;;
	    *) echo "ERROR. run as: combineGvcfs depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run combineGvcfs
combineGvcfsRun () {
    list=$1

    output $1
    OUTPUT=${OUTPUT:-$OUT}
    $GATK -R $REF -T CombineGVCFs \
	  --variant $list \
	  -o $OUTPATH$OUTPUT \
	  -L $bed \
	  -ip $PADDING \
	  -nt $nt

    echo "combineGvcfs run exit status $?"	
}
