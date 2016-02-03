#!/bin/bash

# Start, stop and get status of jobs running on a Torque job scheduler.
#
# Usage:
#
# Starting a job (will print job ID on standard output):
#
#    COMMAND="sleep 180" NAME=test WALLTIME="00:01:00" PROCS=1 QUEUE=batch ./bpipe-torque.sh start
#
# Stopping a job (given some job id "my_job_id")
#
#    ./bpipe-torque.sh stop my_job_id
#
# Getting the status of a job (given some job id "my_job_id")
#
#    ./bpipe-torque.sh status my_job_id
#
# Notes:
#
# None of the commands are guaranteed to succeed. An exit status of 0 for this script
# indicates success, all other exit codes indicate failure (see below).
#
# Stopping a job may not cause it to stop immediately. You are advised to check the
# status of a job after asking it to stop. You may need to poll this value.
#
# We are not guaranteed to know the exit status of a job command, for example if the
# job was killed before the command was run.
#
# Authors: Bernie Pope, Simon Sadedin, Alicia Oshlack
# Copyright 2011.

# This is what we call the program in user messages

#---------------------------------------------------
# This version have been modified
# Author: Gustav, year 2015
#





# Set Path for loading library in PBS script:
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for f in $DIR/../lib/stages/*.sh; do
   . $f
done



#Add default paths for log files
LOGDIR=${LOGDIR:-.}

# Default to 1 node - this can be overridden directly by user
# or alternatively by value of procs via set_procs
NODES=${NODES:-1}



