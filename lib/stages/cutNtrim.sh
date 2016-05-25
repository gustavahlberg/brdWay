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

cutNtrim () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		cutNtrimRun "$1";
		;;
	    depend) shift
		dependCutNTrim "$1";
		;;
	    *) echo "ERROR. run as: cutNtrim depend/run";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}


#vcf=AVNRTLuCamp.Combined.region.vcf
#Run cu
cutNtrimRun () {

    if [[ $# -ge 1 ]]; then
	#then
	fastqFwd=$1
	fastqRev=`echo $fastqFwd |perl -ane 's/_R1_/_R2_/;print $_'`

	if [[ $fastqFwd == *".gz"* ]]; then
	    gunzip $fastqFwd
	    fastqFwd=${fastqFwd%.gz}
	    gunzip $fastqRev
	    fastqRev=${fastqRev%.gz}
	fi
	
	output $fastqFwd
	
	case $RUNCUT in
	    TRUE)
		if [ ! -d "cutadaptStat" ]; then
		    mkdir cutadaptStat;
		fi
	
		cutFwd=$OUTPATH$OUT.cut;
		cutRev=`echo $cutFwd |perl -ane 's/_R1_/_R2_/;print $_'`;
		
		cutadapt -a $adapter_a -A $adapter_A -o $cutFwd -p $cutRev \
		-m $m -O $O -q $q --quality-base=$qualityBase $fastqFwd $fastqRev \
		> cutadaptStat/stat.$OUT.cut;
		echo "running cutadapt"
		;;
	    FALSE) 
		cutFwd=$fastqFwd;
		cutRev=$fastqRev;
		echo "N.B. not running cutadapt"
		;;
	    *) echo "ERROR: set RUNCUT to TRUE/FALSE"
		exit 1;
		;;
	esac

	echo "cutadapt finished"
	
	case $RUNTRIM in
	    TRUE)
		
		cutNtrimFwd=$OUTPATH$(basename $cutFwd).trim;
		cutNtrimRev=`echo $cutNtrimFwd |perl -ane 's/_R1_/_R2_/;print $_'`;
		
		if [ ! -d "prins_graph" ]; then
		    mkdir prins_graph;
		fi
	       
		echo "running prinseq trimming fwd";

		$HOME/bin/prinseq-lite.pl -fastq $cutFwd \
		-graph_data prins_graph/$(basename $cutNtrimFwd).graph \
		-min_len $minLen -min_qual_mean $minQmean -trim_qual_right $trimQright \
		-custom_params $customParam -lc_method $lcMethod \
		-lc_threshold $lcThresh -trim_qual_left $trimQleft -out_good $cutNtrimFwd \
		-out_bad $cutNtrimFwd.prinseq_bad;

		echo "running prinseq trimming rev"
		$HOME/bin/prinseq-lite.pl -fastq $cutRev \
		-graph_data prins_graph/$(basename $cutNtrimRev).graph \
		-min_len $minLen -min_qual_mean $minQmean -trim_qual_right $trimQright \
		-custom_params $customParam -lc_method $lcMethod \
		-lc_threshold $lcThresh -trim_qual_left $trimQleft -out_good $cutNtrimRev \
		-out_bad $cutNtrimFwd.prinseq_bad;
		cutNtrimFwd=$cutNtrimFwd.fastq;
		cutNtrimFwd=$cutNtrimRev.fastq;
		echo "prinseq trimming"
		;;
	    FALSE)
		cutNtrimFwd=$cutFwd;
		cutNtrimRev=$cutRev;
		echo "N.B. not running prinseq"
		;;
	    *) echo "WARN: set RUNTRIM to TRUE/FALSE"
		exit 1;
		;;
	esac
	
	echo "prinseq finished"

	$HOME/bin/cmpfastq.pl $cutNtrimFwd $cutNtrimRev

	gzip $fastqFwd
	gzip $fastqRev
 	
    else
	echo "ERROR: No input file supplied"
    fi
    echo "cutNTrim  run exit status $?"	

}
