#!/bin/bash

#project root
CONFDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$CONFDIR/.."
#================================================
# RESOURCES PATH
RESRC="$ROOT/../RESOURCES"

#Resources
dbsnp="$RESRC/All.vcf.gz"
exac="$RESRC/exac/release0.3/ExAC.r0.3.sites.vep.vcf.gz"
#g1k="$RESRC/exac/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5.20130502.sites.vcf.gz"
#mills="$RESRC/Mills_and_1000G_gold_standard.indels.b37.vcf"
#dbNSFP="$RESRC/dbNSFP2.9.txt.gz"

#g1k.indel = "$RESRC/1000G_phase1.indels.b37.vcf"

# bedfile for defining target region


#bed file default if any
: ${bed=:$RESRC/Broad.human.exome.b37.interval_list}

# REF GENOME
REF="$RESRC/REF/hs.build37.1.fa"


#=================================================
# Annotation paths
#=================================================

#Set path to snpEff.jar
#snpEff="/home/projects/pr_99009/people/salling/snpEff/snpEff.jar"
#snpSift="/home/projects/pr_99009/people/salling/snpEff/SnpSift.jar"
#snpEff="$ROOT/snpEff/snpEff.jar"
#snpSift="$ROOT/snpEff/snpSift.jar"


#==================================================
# Set location for storing large temp files
TMPCONFDIR="$ROOT/temp"

#==================================================
# Set location for Tools
GATK="java -XX:+UseParallelGC -XX:ParallelGCThreads=8 -Xmx8g -Djava.io.tmpdir=$ROOT/temp -jar $HOME/GATK_latest/GenomeAnalysisTK.jar"
GenomeAnalysisToolKit="$HOME/GATK_latest/GenomeAnalysisTK.jar"
