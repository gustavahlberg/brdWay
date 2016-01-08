#!/bin/bash
#
# Author: Gustav
#
#-------------------------------------

PROGNAME=${0##*/}
PROGVERSION=0.1.0   

#---------------------------------------
#
# Load library
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/../lib/stages.sh
. $DIR/../lib/clusterManager.sh
. $DIR/../lib/printStages.sh
torque=$DIR/../bin/bpipe-torque.sh

#--------------------------------------
#
# FUNCTIONS
#

#print usage
usage () {
cat << HERE
Usage: $PROGNAME [options]
$PROGNAME -o <version> -c    
Options:
-h, show this message, -v version information
-p print names of current stages in lib
-c <cluster|locally>
-i <input vcf file>
-a application to run (see $PROGNAME -p)


ADDITIONAL OPTIONS:
additional option will in the future be added to handle an alternative
interactive session or using configured defaults

HERE
}   


#run/execute locally or on cluster
run () {
    echo $1 $2 
    #shift;
    #echo $1
    case $2 in 
	clust* ) runOnCluster $1;;
	loca* ) runOnLocal $1;;
	*) echo "Set -c to locally or cluster";
	    exit 2;
	    ;;
    esac
}

#run on cluster
runOnCluster () {
    while true; do
	read -p "Do you wish to run on cluster with defaults? y/n " yn
	case $yn in
	    [Yy]* ) jobID=`COMMAND="$APP run $1" NAME=$APP $torque start`;
		    if [[ $jobID -eq "" ]];then
			exit 1;
		    fi
		    break;;
	    [Nn]* ) jobID=`customPBS $1`;
		    if [[ $jobID -eq "" ]];then
			exit 1;
		    fi
		    break;;
	    * ) echo "Please answer yes or no.";;
	esac
    done
    
    while true; do
	read -p "Check job status? y/n " yn
	case $yn in
	    [Yy]* ) jobStatus $jobID;;
	    [Nn]* ) break;;
	    * ) echo "Please answer yes or no.";;
	esac
    done
}

#on machine
runOnLocal () {
    $APP run $1 
    echo $!
}


#------------------------------------------------------------------------------------------
#
# MAIN
#

main () {
  if [[ ${#@} < 1 ]]; then
      usage
      exit 1
  fi

  while getopts hvpi:c:a: flag; do
	case "$flag" in
	    
	    i)  INPUT=$OPTARG;
		;;
	    c)  HPC=$OPTARG;
		;;
	    h) usage;
		exit 0
		;;	
	    v) echo Version: $PROGNAME, v.$PROGVERSION;
		exit 0
		;;
	    p) printStages;
	       exit 0
	       ;;
	    a) $APP=$OPTARG;
		;;
	    
            *) usage ;
		exit 1;
		;;
      	esac
	
    done
  shift $(( OPTIND - 1 ));

  #check dependencies
  $APP depend  

  #run job
  run $INPUT $HPC
  echo "job finished"
  #rm job.pbs
}

main "$@"
exit 0
#-----------------------------------------------------------------------------------
