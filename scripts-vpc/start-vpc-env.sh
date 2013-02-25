#!/bin/bash
#latest AMIs: http://uec-images.ubuntu.com/releases/10.04/release/
ssh-keygen -R 10.96.1.*
script_dir="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"

function startServers {
  NO_OF_SERVERS=$1
  for (( x = 1; x <= $NO_OF_SERVERS; x += 1)); do 
    . ./start-single-vpc-server.sh & 
  done
}

[ -z "$ZONE" ] && export ZONE=us-east-1e
[ -z "$ENV" ] && export ENV=dev
[ -z "$ENVGRP" ] && export ENVGRP=$ENV
[ -z "$DISTRO" ] && export DISTRO=chef-full-vpc
[ -z "$SSH_USER" ] && export SSH_USER=ubuntu
[ -z "$SSH_KEY" ] && export SSH_KEY=$script_dir/../ssh-keys/dev.pem
[ -z "$SSH_KEY_NAME" ] && export SSH_KEY_NAME=dev
[ -z "$LOGS" ] && export LOGS=$script_dir/../logs
[ -z "$REGION" ] && export REGION=us-east-1
#[ -z "$AMI" ] && export AMI=ami-5965401c # Ubuntu 10.04.4; West; 64bit
#[ -z "$AMI" ] && export AMI=ami-c7b202ae # Ubuntu 10.04.4; East; 64bit
#[ -z "$AMI" ] && export AMI=ami-3d4ff254 # Ubuntu 12.04.1 LTS; East; 64bit
[ -z "$AMI" ] && export AMI=ami-137bcf7a # Ubuntu 12.04.1 LTS; East; 64bit

[ -z "$TYPE" ] && export TYPE=m1.small
[ -z "$EC2_URL" ] && export EC2_URL=http://ec2.us-east-1.amazonaws.com
[ -z "$EBS_SIZE" ] && export EBS_SIZE=20

if [ $ENVGRP == "dev" ]
then
  GROUP_ENV=sg-66fb1209
  GROUP_COMMON=sg-67fb1208
  GROUP_DB=sg-64fb120b
  GROUP_WEBSERVER=sg-65fb120a
  GROUP_MONITORING=sg-63fb120c
  GROUP_CHEFWORKSPACE=sg-49dc2a26
  GROUP_CACHE=sg-f482739b

fi

if [ ${SERVERS_DB:-0} -ge 1 ]; then
  export ROLE=mysql_magento
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_DB
  export EBS_SIZE=20
  [ -n "$TYPE_DB" ] && export TYPE=$TYPE_DB
  startServers $SERVERS_DB
fi

if [ ${SERVERS_DBSLAVE:-0} -ge 1 ]; then
  export ROLE=mysql_slave
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_DB
  export EBS_SIZE=20
  [ -n "$TYPE_DB" ] && export TYPE=$TYPE_DB
  startServers $SERVERS_DBSLAVE
fi

if [ ${SERVERS_WEB:-0} -ge 1 ]; then
  export ROLE=magento-webonly
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_WEBSERVER
  [ -n "$TYPE_WEBSERVER" ] && export TYPE=$TYPE_WEBSERVER
  startServers $SERVERS_WEB
fi

if [ ${SERVERS_MAINTENANCE_PAGE:-0} -ge 1 ]; then
  export ROLE=maintenance-page
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_WEBSERVER
  [ -n "$TYPE_WEBSERVER" ] && export TYPE=$TYPE_WEBSERVER
  startServers $SERVERS_MAINTENANCE_PAGE
fi


if [ ${SERVERS_MONITORING:-0} -ge 1 ]; then
  export ROLE=monitoring
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_MONITORING
  [ -n "$TYPE_MONITORING" ] && export TYPE=$TYPE_MONITORING
  startServers $SERVERS_MONITORING
fi

if [ ${SERVERS_MONITORINGII:-0} -ge 1 ]; then
  export ROLE=monitoring2
  export SSH_USER=admin
  export AMI=ami-4d20a724 #Debian 6.0.6 us-east-1 64bit
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_MONITORING
  startServers $SERVERS_MONITORINGII
fi

if [ ${SERVERS_GLACIERTEST:-0} -ge 1 ]; then
  export ROLE=magento-glacier
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_WEBSERVER,$GROUP_DB
  [ -n "$TYPE_GLACIERTEST" ] && export TYPE=$TYPE_GLACIERTEST
  startServers $SERVERS_GLACIERTEST
fi

if [ ${SERVERS_CHEFWORKSPACE:-0} -ge 1 ]; then
  export ROLE=chef-workspace
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_CHEFWORKSPACE
  [ -n "$TYPE_CHEFWORKSPACE" ] && export TYPE=$TYPE_CHEFWORKSPACE
  startServers $SERVERS_CHEFWORKSPACE
fi

if [ ${SERVERS_CLOUDERA:-0} -ge 1 ]; then
  export ROLE=cloudera
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_CLOUDERA
  [ -n "$TYPE_CLOUDERA" ] && export TYPE=$TYPE_CLOUDERA
  startServers $SERVERS_CLOUDERA
fi

if [ ${SERVERS_SPLUNK:-0} -ge 1 ]; then
  export ROLE=splunkserver
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON
  [ -n "$TYPE_SPLUNK" ] && export TYPE=$TYPE_SPLUNK
  startServers $SERVERS_SPLUNK
fi

if [ ${CLIENTS_SPLUNK:-0} -ge 1 ]; then
  export ROLE=apachemodsecurity
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON
  [ -n "$TYPE_CLIENTSSPLUNK" ] && export TYPE=$TYPE_CLIENTSPLUNK
  startServers $CLIENTS_SPLUNK
fi

if [ ${SERVERS_CACHE:-0} -ge 1 ]; then
  export ROLE=cache
  export SEC_GROUPS=$GROUP_ENV,$GROUP_COMMON,$GROUP_CACHE
  [ -n "$TYPE_CACHE" ] && export TYPE=$TYPE_CACHE
  startServers $SERVERS_CACHE
fi


unset `env | grep SERVERS_ | cut -d"=" -f1`
unset `env | grep GROUP_ | cut -d"=" -f1`
unset ZONE
unset ENV
unset ENVGRP
unset SSH_KEY
unset SSH_KEY_NAME
unset SSH_USER
unset LOGS
unset REGION
unset AMI
unset TYPE
unset EC2_URL
unset EBS_SIZE
unset SEC_GROUPS
