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
	echo "ERROR: A variable has no value. Check config file"
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

#check dependencies of variants to table
dependVariantsToTable () {
    #checking typical GATK depenencies
    dependGATK
    echo "dependencies for VariantsToTable: OK"
    # tool specific dependencies here
    # ....
}


dependSelectVariantRegion () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    echo $BED
    fileCheck $bed
    echo "dependencies for SelectVariantRegion: OK"
}


#check dependencies for GATK select variants (select samples & remove samples)
dependSelectVariantSample () {
    #checking typical GATK depenencies
    dependGATK
    # tool specific dependencies here
    fileCheck $bed
    fileCheck $LIST
    echo "dependencies for SelectVariantRegion: OK"
}


