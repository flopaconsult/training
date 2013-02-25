#!/bin/bash
#latest AMIs: http://uec-images.ubuntu.com/releases/10.04/release/
script_dir="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"

export ENV=dev
export ENVGRP=dev # security-groups
export SUBNET=subnet-963364fd
export EBS_SIZE=8

#export SERVERS_DB=1
#export SERVERS_DBSLAVE=1
#export SERVERS_WEB=1
#export SERVERS_MONITORING=1
export SERVERS_CHEFWORKSPACE=1

. $script_dir/start-vpc-env.sh

