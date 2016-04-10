#!/bin/bash
#
# Author: Gustav 
# 
#-----------------------------------------
#
# Usage: Library will contains functions that will
# check dependencies for the stages functions in
# Library stages.sh
#------------------------------------------

variableCheck () {
    if [ ! $1 ]; then 
	echo "ERROR: A variable has no value";
	exit 1;
    else 
	echo "var is set to $1"; 
    fi
}

command_exists () {
    
    type "$1" &> /dev/null ;
    if [ $? -eq 1 ]; then
	echo "ERROR: Check installation of $1"
	return 1
    fi
}

fileCheck () {
    FILE=$1
    if [[ $# -eq "" ]]; then
	echo "ERROR: A file variable, has no value. Check config file"
	exit 1
    fi
    
    if [ ! -f $FILE ];
    then
	echo "ERROR: File $FILE does not exist."
	echo "ERROR: Check your config file in configir directory"
	exit 1
    fi
    

}

#check dependencies for GATK
dependGATK () {
    #java,gatk,reference genome
    f=0
    fileCheck $REF
    echo $REF
    fileCheck ${REF%.fa}.dict
    fileCheck $GenomeAnalysisToolKit
    command_exists java
   
}



#---------------------------------------------------------
#
# Stage specfic dependencies checks
#

#--------------------------------------------
#check dependencies of variants to table
dependVariantsToTable () {
    #checking typical GATK depenencies
    dependGATK
    echo "dependencies for VariantsToTable: OK"
    # tool specific dependencies here
    # ....
}

#--------------------------------------------
dependSelectVariantRegion () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    echo $bed
    fileCheck $bed
    echo "dependencies for SelectVariantRegion: OK"
}

#--------------------------------------------
#check dependencies for GATK select variants (select samples & remove samples)
dependSelectVariantSample () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    fileCheck $bed
    fileCheck $LIST
    echo "dependencies for SelectVariantRegion: OK"
}


#--------------------------------------------
#check dependencies for GATK VariantEval
dependVariantEval () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    fileCheck $dbsnp
    echo $dbsnp
    fileCheck $exac
    echo $exac
    fileCheck $bed
    echo "dependencies for VariantEval: OK"
}

#--------------------------------------------
#check dependencies for covHist
dependCovHist () {
    #checking if bedtools is installed
    command_exists bedtools
    # check bedfile
    fileCheck $bed
    echo $bed
    echo "dependencies for covHist: OK"
}

#--------------------------------------------
#check dependencies for callabeLoci
dependCallableLoci () {
    #checking typical GATK depenencies
    dependGATK
    fileCheck $bed
    echo $bed
    echo "dependencies for callableLoci: OK"
}


#--------------------------------------------
#check dependencies for GATK select variants selectType
dependSelectType () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    echo "Type selected:"$TYPE
    variableCheck $TYPE
    echo "dependencies for SelectType: OK"
}

#--------------------------------------------
#check dependencies for GATK hard filtering
dependvariantFiltration () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    echo "filterExpression:" $filterExpression
    variableCheck $filterExpression
    echo "dependencies for variantFiltration: OK"
}
#--------------------------------------------
#check dependencies for GATK VQSR variant recalibrator

dependvariantRecalibrator () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    variableCheck $TYPE

    case $TYPE in
	SNP) dependvariantRecalibratorSNP "$1";
	    ;;
	INDEL) dependvariantRecalibratorINDEL $1;
	    ;;
	*) echo "ERROR. set TYPE var to \"SNP\" or \"INDEL\"";
	    exit 1
	    ;;
    esac

    echo "dependencies for variantRecalibrator: OK"
}

dependvariantRecalibratorSNP () {
    fileCheck $HAPMAP
    fileCheck $OMNI
    fileCheck $G1K
    fileCheck $dbsnp

}

dependvariantRecalibratorINDEL () {
    fileCheck $MILLS
}

#--------------------------------------------
#check dependencies for GATK VQSR apply recalibration

dependapplyRecalibration () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    fileCheck $RECAL
    fileCheck $TRANCHES
    variableCheck $FILTERLEVEL
    variableCheck $TYPE
    echo "dependencies for applyRecalibration: OK"
}

#--------------------------------------------

