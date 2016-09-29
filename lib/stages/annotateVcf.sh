#!/bin/bash
#
# Author: Gustav 
# 
#
#
#-----------------------------------------
#source configurations
#STAGEDIR=/home/projects/cu_10039/apps/brdWay/lib/stages


STAGEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $STAGEDIR/../../configDir/config.sh
. $STAGEDIR/../../lib/dependCheck.sh
. $STAGEDIR/../output.sh
PWD=`pwd`
PWD=${PWD%/}
: ${outdir:=$PWD}

#echo $PWD
#echo $outdir
#-----------------------------------------
#
# select variant in region defined by bed file
#

annotateVcf () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 annotateVcfRun "$1";
		 ;;
	    depend) shift
		    dependAnnotateVcf "$1";
		    ;;
	    *) echo "ERROR. run as: annotateVcf depend/run";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}


#vcf=AVNRTLuCamp.Combined.region.vcf
#Run annotateVCF
annotateVcfRun () {

    if [[ $# -ge 1 ]]; then
	#then
	vcf=$1
       	output $vcf

	case $RUNEFF in
	    TRUE)
		annon=$SCRATCH/${OUT%.vcf}.annon.vcf;
		java -XX:+UseParallelGC -XX:ParallelGCThreads=8 -Xmx16g -Djava.io.tmpdir=$SCRATCH/TMP -jar $snpEff -v GRCh37.75 -classic $vcf > $annon;
		echo "running snpEFf"
		;;
	    FALSE) 
		annon=$vcf
		echo "N.B. not running snpEff"
		;;
	    *) echo "ERROR: set RUNDBNSFP to TRUE/FALSE"
		exit 1;
		;;
	esac

	
	case $RUNDBNSFP in
	    TRUE) 
		annon_dbnsfp=$SCRATCH/$(basename ${annon%.vcf}).dbNSFP.vcf
		java -jar $snpSift dbnsfp -v -db $dbNSFP $annon -f $AnnoDbNSFP > $annon_dbnsfp
		#rm $anno;
		echo "running snpsift dbnspf annotation"
		;;
	    FALSE)
		annon_dbnsfp=$annon;
		echo "N.B. not running dbnsfp annotation"
		;;
	    *) echo "WARN: set RUNDBNSFP to TRUE/FALSE"
		exit 1;
		;;
	esac
	
	output $annon_dbnsfp
	OUTPUT=${OUTPUT:-$OUT}
	mv $annon_dbnsfp $OUTPUT 
	
	#clean


    else
	echo "ERROR: No input file supplied"
    fi
    echo "annotateVcf  run exit status $?"	

}
