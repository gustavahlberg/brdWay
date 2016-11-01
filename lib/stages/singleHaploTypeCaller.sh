#!/bin/bash
#
# Author: Gustav 
# Single sample Haplotypecaller stage
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

singleHaploTypeCaller () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 singleHaploTypeCallerRun "$1";
		 ;;
	    depend) shift
		    dependSingleHaploTypeCaller "$1";
		    ;;
	    *) echo "ERROR. run as: singleHaploTypeCaller depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run singleHaploTypeCaller
singleHaploTypeCallerRun () {
    in=$1

    output $1
    OUT=${OUT%.bam}.g.vcf
    OUTPUT=${OUTPUT:-$OUT}

    $GATK -T HaplotypeCaller -R $REF \
	  -I $in \
	  --emitRefConfidence GVCF \
	  --dbsnp $dbsnp138 \
	  -L $bed \
	  -o $OUTPATH$OUTPUT
    echo "haplotTypeCaller run exit status $?"	
}
