#!/bin/bash
#
# Author: Gustav 
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

indelReAln () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		indelReAlnRun "$1";
		 ;;
	    depend) shift
		dependIndelReAln "$1";
		    ;;
	    *) echo "ERROR. run as: indelReAln depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run indelReAln
indelReAlnRun () {
    bam=$1
    output $bam

    case $RUNINDELALNRECAL in
	TRUE)
	    indelReInterval=${indelReInterval:-indelTargets/$OUT.intervals};
	    RealignerTargetCreator 
	    ;;
	FALSE) 
	    indelReInterval=${indelReInterval:-indelTargets/$OUT.intervals};
	    echo "N.B. not running RealignerTargetCreator"
	    ;;
	*) echo "ERROR: set RUNINDELALNRECAL to TRUE/FALSE";
	    exit 1
	    ;;
    esac
    
    case $RUNINDELALNAPPLY in
	TRUE)
	    OUT=${OUT%.bam}.realn.bam
	    OUTPUT=${OUTPUT:-$OUT}
	    IndelRealigner 
	    ;;
	FALSE) 
	    echo "N.B. not running RealignerTargetCreator"
	    ;;
	*) echo "ERROR: set RUNINDELALNRECAL to TRUE/FALSE"
	    exit 1;
	    ;;
    esac

}
    


#============================================================
# RealignerTargetCreator
#============================================================

RealignerTargetCreator () {

    if [ ! -d "indelTargets" ]; then
	mkdir indelTargets;
    fi
	
    $GATK -T RealignerTargetCreator -R $REF \
    -I $bam \
    -o $indelReInterval \
    -known $G1Kindel \
    -known $MILLS \
    -L $bed \
    --interval_padding $PADDING \
    -nt $nt

}




#============================================================
# IndelRealigner
#============================================================


IndelRealigner () {

    $GATK -T IndelRealigner -R $REF \
    -I $bam \
    -targetIntervals $indelReInterval \
    -o $OUTPATH$OUTPUT \
    -known $G1Kindel \
    -known $MILLS \

    echo "RealignerTargetCreator run exit status $?"	

}






