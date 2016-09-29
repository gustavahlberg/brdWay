#!/bin/bash
#
# Author: Gustav 
# genotypeGvcfs. Give input in a list <list>.list or a single file 
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

genotypeGvcfs () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 genotypeGvcfsRun "$1";
		 ;;
	    depend) shift
		    dependGenotypeGvcfs "$1";
		    ;;
	    *) echo "ERROR. run as: genotypeGvcfs depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run genotypeGvcfs
genotypeGvcfsRun () {
    $list=$1
    output $1
    OUTPUT=${OUTPUT:-$OUT}
    $GATK -R $REF -T GenotypeGVCFs \
	  --variant $list \
	  -o $OUTPATH$OUTPUT \
	  -L $bed \
	  -ip $PADDING \
	  -nt $nt

    echo "genotypeGvcfs run exit status $?"	
}
