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
# BQSR by gatk
#

bqsr () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		bqsrRun "$1";
		 ;;
	    depend) shift
		#dependBqsr "$1";
		    ;;
	    *) echo "ERROR. run as: bqsr depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run indelReAln
bqsrRun () {
    bam=$1
    output $bam

    OUTPUT=${OUTPUT:-${OUT%.bam}.recal.bam}
    reCalBefore=${reCalBefore:-recalBQSR/$OUT.grp}
    reCalAfter=${reCalAfter:-recalBQSR/$OUTPUT.grp};

    case $RUNBQSRRECAL in
	TRUE)
	    BaseRecalibrator $reCalBefore $bam
	    ;;
	FALSE) 
	    echo "N.B. not running BaseRecalibrator"
	    ;;
	*) echo "ERROR: set RUNBQSRRECAL to TRUE/FALSE";
	    exit 1
	    ;;
    esac
    
    case $RUNBQSRAPPLY in
	TRUE)	    
	    PrintReads $bam
	    ;;
	FALSE)
	    OUTPUT=${OUTPUT:-$bam}
	    echo "N.B. not running PrintReads"
	    ;;
	*) echo "ERROR: set RUNBQSRAPPLY to TRUE/FALSE"
	    exit 1;
	    ;;
    esac
    
    case $RUNBQSRRECALAFTER in
	TRUE)
	    #if RUNBQSRAPPLY=FALSE do not supply OUTPATH (leave empty) as path to recal input bam
	    BaseRecalibrator $reCalAfter $OUTPATH$OUTPUT
	    ;;
	FALSE) 
	    echo "N.B. not running BaseRecalibrator After"
	    ;;
	*) echo "ERROR: set RUNBQSRRECALAFTER to TRUE/FALSE"
	    exit 1;
	    ;;
    esac

    case $RUNBQSRANALYSCOVAR in
	TRUE)
	    AnalyzeCovariates
	    ;;
	FALSE) 
	    echo "N.B. not running RealignerTargetCreator"
	    ;;
	*) echo "ERROR: set RUNBQSRANALYSCOVAR to TRUE/FALSE"
	    exit 1;
	    ;;
    esac


}
    


#============================================================
# BaseRecalibrator GATK
#============================================================

BaseRecalibrator () {

    reCal=$1
    bamFile=$2

    if [ ! -d "recalBQSR" ]; then
	mkdir recalBQSR;
    fi
    
	
    $GATK -T BaseRecalibrator -R $REF \
    -I $bamFile \
    -L $bed \
    --interval_padding $PADDING \
    -knownSites $dbsnp \
    -knownSites $MILLS \
    -knownSites $G1Kindel \
    -o $reCal 
    
    echo "BaseRecalibrator run exit status $?"	
}




#============================================================
# PrintReads
#============================================================


PrintReads () {

    $GATK -T PrintReads -R $REF \
    -I $bam \
    -BQSR $reCalBefore \
    -o $OUTPATH$OUTPUT
   
    echo "PrintReads run exit status $?"	

}

#============================================================
# AnalyzeCovariates
#============================================================


AnalyzeCovariates () {

    if [ ! -d "recalBQSR" ]; then
	mkdir recalBQSR;
    fi
    
    if [ ! -d "recalBQSRplots" ]; then
	mkdir recalBQSRplots;
    fi

    reCalPdf=${reCalPdf:-recalBQSRplots/recal.$OUT.pdf}
    csv=${csv:-$reCalBefore.csv}

    $GATK -T AnalyzeCovariates -R $REF \
    -csv $csv \
    -before $reCalBefore \
    -after $reCalAfter \
    -plots $reCalPdf
   
    echo "AnalyzeCovariates run exit status $?"	
}



