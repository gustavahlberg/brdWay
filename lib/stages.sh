#!/bin/bash
#
# Author: Gustav 
# 
#
#
#-----------------------------------------
#source configurations

STAGEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $STAGEDIR/../configDir/config.sh
. $STAGEDIR/../lib/dependCheck.sh
PWD=`pwd`
PWD=${PWD%/}
: ${outdir:=$PWD}

#-----------------------------------------
# Function: variantsToTables
# Creates a table of a vcf using gatk varintsToTables
#

# create vcf specific option string
infoString() {
    head -1000 $1 | grep '#' > header
    grep 'INFO=<' header > info
    COL=`cat info | perl -ane 'chomp;$_=~m/##INFO=<ID=([^,]*)/;print " -F $1"'`
    echo ${COL%" "}
    rm info header
}


#parse function variantsToTable
variantsToTable () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 variantsToTableRun "$@";
		 ;;
	    depend) dependVariantsToTable;
		    ;;
	    *) echo "ERROR. run as: variantsToTable depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run variants to table
variantsToTableRun () {

    if [[ $# -ge 1 ]]; then
	#then	
	COLUMNS=`infoString $1`

	$GATK -R $REF -T VariantsToTable -V $1\
	--showFiltered --allowMissingData\
	-o $1.table\
	-F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F FILTER\
	$COLUMNS\
	-GF GT -GF AD -GF DP -GF GQ -GF PL
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantToTable run exit status $?"	

}

#-----------------------------------------
#
# select variant in region defined by bed file
#

selectVariantRegion () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 selectVariantRegionRun "$@";
		 ;;
	    depend) shift
		    dependSelectVariantRegion "$@";
		    ;;
	    *) echo "ERROR. run as: variantsToTable depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run selectVariants
selectVariantRegionRun () {

    if [[ $# -ge 1 ]]; then
	#then
	vcf=$1
	#bed=$2
	#default cores 4
	: ${NT:=4}
	in=$(basename $vcf)
	out=${in%.*}.selectRegion.vcf

	$GATK -R $REF -T SelectVariants -V $vcf\
	-L $bed\
	-o $outdir/$out\
	-nt $NT\
	-selectType INDEL -selectType SNP\
	--interval_padding 50
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantToTable run exit status $?"	

}


#-----------------------------------------
#
# select samples in region defined by bed file
#

selectVariantSamples () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 selectVariantsSampleRun "$@";
		 ;;
	    depend) shift
		    dependSelectVariantSample "$@";
		    ;;
	    *) echo "ERROR. run as: selectVariantSamples depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run selectVariants
selectVariantsSampleRun () {

    if [[ $# -ge 1 ]]; then
	vcf=$1
	#default cores 1
	: ${NT:=1}
	in=$(basename $vcf)
	out=${in%.*}.selectSamples.vcf

	$GATK -R $REF -T SelectVariants -V $vcf\
	-L $bed\
	-o $outdir/$out\
	-nt $NT\
	--sample_file $LIST
	--interval_padding 50
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantToTable run exit status $?"	

}


#-----------------------------------------
#
# Remove samples from a vcf
#

selectVariantsRemoveSample () {

    if [[ $# -ge 1 ]]; then
	case "$1" in
	    run) shift
		 selectVariantsRemoveSampleRun "$@";
		 ;;
	    depend) shift
		    dependSelectVariantSample "$@";
		    ;;
	    *) echo "ERROR. run as: selectVariantsRemoveSample depend/run ";
	       exit 1
	       ;;
	esac
    else
	echo "ERROR: No input file supplied"
    fi
    	   
}

#Run selectVariants
selectVariantsRemoveSampleRun () {

    if [[ $# -ge 1 ]]; then
	vcf=$1
	#default cores 1
	: ${NT:=1}
	in=$(basename $vcf)
	out=${in%.*}.selectSamples.vcf

	$GATK -R $REF -T SelectVariants -V $vcf\
	-o $outdir/$out\
	-nt $NT\
	--exclude_sample_file  $LIST
    else
	echo "ERROR: No input file supplied"
    fi
    echo "variantToTable run exit status $?"	

}

