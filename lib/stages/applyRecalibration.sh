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

applyRecalibration () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		applyRecalibrationRun "$1";
		 ;;
	    depend) shift
		    dependapplyRecalibration "$1";
		    ;;
	    *) echo "ERROR. run as: applyRecalibration depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run applyRecalibration
applyRecalibrationRun () {
    if [[ $# -ge 1 ]]; then
	vcf=$1
	output $vcf
	echo $filterExpression
	OUT=${OUT%.vcf}.recal$TYPE.vcf
	OUTPUT=${OUTPUT:-$OUT}
	

	$GATK -T ApplyRecalibration -R $REF \
	-input $vcf \ 
	-mode $TYPE \ 
	--ts_filter_level $FILTERLEVEL \ 
	-recalFile $RECAL \ 
	-tranchesFile $TRANCHES \ 
	-o $OUTPUT \
	-nt $nt



    else
	echo "ERROR: No input file supplied"
    fi
    echo "applyRecalibrationRun run exit status $?"	

}

