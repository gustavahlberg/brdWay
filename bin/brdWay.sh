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

for f in $DIR/../lib/stages/*.sh; do
    . $f
done
. $DIR/../lib/clusterManager.sh
. $DIR/../lib/printStages.sh
. $DIR/../lib/output.sh
. $DIR/../configDir/config.sh
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
    #echo $1 $2 
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
    NAME=${NAME:-$1}
    jobID=`sendPBS $1`;    
    
    while true; do
	STATUS=`jobStatus $jobID`
	#echo $STATUS
	echo $jobID
	echo "HEJ HEJ HEJ "
	case $STATUS in
	    W|R) sleep 20;; #if job is still running 
	    C*) 
		echo "COMPLETE $command_exit_status";
		break;;		# 
	    *) 
		echo ERROR: job did not complete run;
		
		break;;
	    
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
	    a)  APP=$OPTARG;
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
	    
            *) usage ;
		exit 1;
		;;
      	esac
	
    done
  shift $(( OPTIND - 1 ));
  
  
  #check dependencies
  $APP depend  

  echo "Running $APP..........."
  echo "..........."

  #run job
  run $INPUT $HPC
  echo "job finished"
  #rm job.pbs
}

main "$@"
exit 0
#-----------------------------------------------------------------------------------
