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

variantRecalibrator () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		variantRecalibratorRun "$1";
		 ;;
	    depend) shift
		    dependvariantRecalibrator "$1";
		    ;;
	    *) echo "ERROR. run as: variantFiltration depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run selectVariants
variantFiltrationRun () {
    if [[ $# -ge 1 ]]; then
	vcf=$1
	output $vcf
	echo $filterExpression
	OUT=${OUT%.vcf}.$HARDFILTER.vcf
	
	$GATK -T VariantRecalibrator -R $REF \
	-input $vcf \ 
        --filterName $HARDFILTER \
	-o $OUT
	-resource:hapmap,known=false,training=true,truth=true,prior=15.0 $HAPMAP \ 
	-resource:omni,known=false,training=true,truth=true,prior=12.0 $OMNI \ 
	-resource:1000G,known=false,training=true,truth=false,prior=10.0 $G1K \ 
	-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $dbsnp138 \ 
	-an DP \ 
	-an QD \ 
	-an FS \ 
	-an SOR \ 
	-an MQ \
	-an MQRankSum \ 
	-an ReadPosRankSum \ 
	-an InbreedingCoeff \
	-mode SNP \ 
	-tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 \ 
	-recalFile recalibrate_SNP.recal \ 
	-tranchesFile recalibrate_SNP.tranches \ 
	-rscriptFile recalibrate_SNP_plots.R 

    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantFiltrationRun run exit status $?"	

}

    -resource:hapmap,known=false,training=true,truth=true,prior=15.0 hapmap.vcf \ 
    -resource:omni,known=false,training=true,truth=true,prior=12.0 omni.vcf \ 
    -resource:1000G,known=false,training=true,truth=false,prior=10.0 1000G.vcf \ 
    -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 dbsnp.vcf \ 
    -an DP \ 
    -an QD \ 
    -an FS \ 
    -an SOR \ 
    -an MQ \
    -an MQRankSum \ 
    -an ReadPosRankSum \ 
    -an InbreedingCoeff \
    -mode SNP \ 
    -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 \ 
    -recalFile recalibrate_SNP.recal \ 
    -tranchesFile recalibrate_SNP.tranches \ 
    -rscriptFile recalibrate_SNP_plots.R 
