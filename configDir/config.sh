#!/bin/bash

#project root
CONFDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$CONFDIR/.."
GRPROOT="$ROOT/../.."
SCRATCH=$GRPROOT/scratch

#================================================
#
# Default PBS submission settings
#
#

#job name
NAME=${NAME:-$INPUT}
#Walltime
WALLTIME=${WALLTIME:-36000}
#Process
PROCS=${PROCS:-1}
#Memory (GB)
MEMORY=${MEMORY:-4}
#Queue
QUEUE=${QUEUE:-batch}


#================================================
#
# Some default variables
#
OUTPATH=${OUTPATH:-""}

PADDING=${PADDING:-100} #set default padding
ANNOTATIONS_SNPS=${ANNOTATIONS_SNPS:-"-an QD -an FS -an SOR -an MQ -an MQRankSum -an ReadPosRankSum -an InbreedingCoeff"}
ANNOTATIONS_INDELS=${ANNOTATIONS_INDELS:-"-an QD -an FS -an SOR -an MQRankSum -an ReadPosRankSum -an InbreedingCoeff"}
nt=${nt:-1}
nct=${nct:-1}
HARDFILTER=${HARDFILTER:-"HD"}

#SnpEff
RUNEFF=${RUNEFF:-TRUE}
RUNDBNSFP=${RUNDBNSFP:-TRUE}

#cutNtrim
RUNCUT=${RUNCUT:-TRUE}
RUNTRIM=${RUNTRIM:-TRUE}

#indelReAln
RUNINDELALNRECAL=${RUNINDELALNRECAL:-TRUE}
RUNINDELALNAPPLY=${RUNINDELALNAPPLY:-TRUE}

#bqsr
RUNBQSRRECAL=${RUNBQSRRECAL:-TRUE}
RUNBQSRAPPLY=${RUNBQSRAPPLY:-TRUE}
RUNBQSRRECALAFTER=${RUNBQSRRECALAFTER:-TRUE}
RUNBQSRANALYSCOVAR=${RUNBQSRANALYSCOVAR:-TRUE}

#dbNSFP annotation string
AnnoDbNSFP=${AnnoDbNSFP:-'1000Gp1_AC,1000Gp1_AF,1000Gp1_EUR_AF,ESP6500_EA_AF,GERP++_RS,Uniprot_acc,MutationTaster_pred,FATHMM_pred,SIFT_pred,SIFT_converted_rankscore,Polyphen2_HDIV_pred,Polyphen2_HDIV_rankscore,Polyphen2_HVAR_rankscore,Polyphen2_HVAR_pred,MutationAssessor_rankscore,MutationAssessor_pred,LRT_converted_rankscore,LRT_pred,LRT_Omega,ExAC_Adj_AF,ExAC_NFE_AF,clinvar_clnsig,clinvar_trait,PROVEAN_pred,GERP++_NR,SIFT_score,FATHMM_score,MetaSVM_score,MetaSVM_rankscore,MetaSVM_pred,Reliability_index,PROVEAN_score,phyloP46way_primate,phyloP100way_vertebrate'}

#cutadapt


adapter_a=${adapter_a:-'AGATCGGAAGAGCACACGTCTGAACTCCAGTCA'} #haloplex adapters
adapter_A=${adapter_A:-'AGATCGGAAGAGC'} #haloplex adapters
m=${m:-30} 
O=${O:-3}
q=${q:-20}
qualityBase=${qualityBase:-33}

#prinseq

prinseq=$HOME/bin/prinseq-lite.pl
minLen=${minLen:-21}
minQmean=${minQmean:-20}
trimQright=${trimQright:-5}
trimQleft=${trimQleft:-5}
customParam=${customParam:-"A 15;T 15;"}
lcMethod=${lcMethod:-"dust"}
lcThresh=${lcThresh:-60}

#CMPfastq.pl
CMPfastq=$HOME/bin/cmpfastq.pl
#================================================
#
# RESOURCES PATH
#

RESRC=${RESRC:-"$GRPROOT/data/RESOURCES/"}


#================================================
#
# RESOURCES GATK VQSR, BQSR, IndelRealignment
#

HAPMAP=${HAPMAP:-$RESRC/hapmap_3.3.b37.sites.vcf}
OMNI=${OMNI:-$RESRC/1000G_omni2.5.b37.sites.vcf}
G1K=${G1K:-$RESRC/1000G_phase1.snps.high_confidence.b37.vcf}
G1Kindel=${G1Kindel:-$RESRC/1000G_phase1.indels.b37.vcf}
dbsnp138=${dnsnp138:-$RESRC/dbsnp_138.b37.vcf}
MILLS=${MILLS:-$RESRC/Mills_and_1000G_gold_standard.indels.b37.vcf}

#Resources
dbsnp="$RESRC/All.vcf.gz"
exac="$RESRC/exac/release0.3/ExAC.r0.3.sites.vep.vcf.gz"
dbSnp_ExOver129=$RESRC/dbsnp_138.b37.excluding_sites_after_129.vcf.gz
#g1k="$RESRC/exac/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5.20130502.sites.vcf.gz"

dbNSFP=${dbNSFP:-"$RESRC/dbNSFP2.9.txt.gz"}

#g1k.indel = "$RESRC/1000G_phase1.indels.b37.vcf"

# bedfile for defining target region


#bed file default if any
bed=${bed:-$RESRC/Broad.human.exome.b37.interval_list}


# REF GENOME
REF=${REF:-"$RESRC/REF/hs.build37.1.fa"}


# GATK minGenotypeQuality 
MPG=${MPG:-0}



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
# Set location for Tool
#GenomeAnalysisToolKit="$GRPROOT/TOOLS/GATK_latest/GenomeAnalysisTK.jar"

GenomeAnalysisToolKit=${GenomeAnalysisToolKit:-$GRPROOT/TOOLS/GATK_latest/gatk3.4/GenomeAnalysisTK.jar}
GATK="java -XX:+UseParallelGC -XX:ParallelGCThreads=8 -Xmx16g -Djava.io.tmpdir=$SCRATCH/TMP -jar $GenomeAnalysisToolKit"


#==================================================
# Set location for SnpEff

snpEff=${snpEff:-$GRPROOT/TOOLS/snpEff/snpEff.jar}
snpSift=${snpSift:-$GRPROOT/TOOLS/snpEff/SnpSift.jar}

#==================================================
# Set location for prinseq-lite

prinseq=$HOME/bin/prinseq-lite.pl

#==================================================
# Set location for cmpfastq.pl
