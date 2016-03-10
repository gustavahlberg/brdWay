#!/bin/bash
#
# Author: Gustav
#
#-------------------------------------
# FUNCTIONS to manage job submissions
# for torque hpc.



#write settings for PBS script 
sendPBS () {
    COMMAND="$APP run $1" STAGE=$APP.sh NAME=$NAME WALLTIME=$WALLTIME MEMORY=$MEMORY PROCS=$PROCS QUEUE=batch $torque start;
}


#write settings for PBS script interactive 
customPBS () {
    read -p "Walltime?: " WALLTIME
    read -p "NAME?: " NAME
    read -p "Processes?: " PROCS
    read -p "Memory?: " MEMORY  
    COMMAND="$APP run $1" STAGE=$APP.sh NAME=$NAME WALLTIME=$WALLTIME MEMORY=$MEMORY PROCS=$PROCS QUEUE=batch $torque start;
}

#check job on cluster
jobStatus () {
    #sleep 2
    STAT=`$torque status $1`
    echo $STAT
    #while [ ${finished} ];do  
#	sleep 60
#	finished=`qstat -r -u salling | awk '{print $10}' | sort | uniq | grep R`   
#    done   
}
