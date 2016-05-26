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

alignBwa () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		alignBwaRun "$1";
		 ;;
	    depend) shift
		    dependAlignBwa "$1";
		    ;;
	    *) echo "ERROR. run as: alignBwa depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run variantRecalibrator
alignBwaRun () {
    fwd=$1
    rev=`echo $fwd |perl -ane 's/_R1_/_R2_/;print $_'`

    fixHeader $fwd
    echo "header: $header"
    echo "input: $fwd $rev"
    echo "running bwa"
    bwa mem -t 4 -M -R $header $REF $fwd $rev | samtools view -Sb - > $OUTPATH$bam
    echo "running samtools sort"
    samtools sort $OUTPATH$bam $OUTPATH$sort
    echo "running samtools index"
    samtools index $OUTPATH$sortout
    	     
}

#creating a header for bam file
fixHeader() {
    input=$1
    tmp=$(basename ${input%_L*})
    sample=$tmp
    bam=$tmp.bam
    sort=$tmp.sort
    sortout=$sort.bam
    id=${input%_S*}
    id=$(basename $id)
    header='@RG\tID:'$id'\tSM:'$sample'\tPL:ILLUMINA\tLB:lib-'$id
}


