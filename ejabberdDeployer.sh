#!/bin/sh
RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'
GREEN='\033[0;32m'

LOCAL_WORK_DIRECTORY="/Users/hare.kumar/Documents/workspace/shopochat-erl"
REMOTE_APP_DIRECTORY="/apps/ejabberd-15.04"
USER_REMOTE_HOME_DIRECTORY='/home/hk15052'
REMOTE_USER_NAME='hk15052'
LOCAL_BEAM_FILE_DIRECTORY='/Users/hare.kumar/Documents/workspace/shopochat-erl/ebin'

DEPLOY_SCRIPT="deploy_script.sh"

scpAndSsh() {
    
    echo $1

    for host in "${@}"
    do
        # scp ebin/* hk15052@52.74.132.72:/home/hk15052
        echo "${GREEN}scp $LOCAL_BEAM_FILE_DIRECTORY/* $REMOTE_USER_NAME@$host:$USER_REMOTE_HOME_DIRECTORY ${NC}"
        scp $LOCAL_BEAM_FILE_DIRECTORY/* $REMOTE_USER_NAME@$host:$USER_REMOTE_HOME_DIRECTORY
        echo "${GREEN}File has been successfully copied to remote destination ${host} ${NC}"
    done

    for host in "${@}"
    do
        # ssh hk15052@52.74.132.72
        echo "ssh to $host"
        ssh -t $REMOTE_USER_NAME@$host sudo ./$DEPLOY_SCRIPT $2 

    done

    echo "${GREEN}********* DEPLOYMENT ON $ENV FINISHED ********** ${NC}"
}

ENV=$1
# List of development & staging ejabberd host
staging=( "52.74.89.13" "52.74.18.97" )
dev=( "52.74.132.72" )

echo "${BLUE} Navigating to local work directory to compile erlang source code ${NC}"
cd $LOCAL_WORK_DIRECTORY && erlc -I /Applications/ejabberd-15.04/lib/ejabberd-15.04/include -o ebin -DNO_EXT_LIB -pa /Applications/ejabberd-15.04/lib/ejabberd-15.04/ebin src/*.erl

echo "" 

echo "${RED}selected enviorment $ENV ${NC}"

if [ "$ENV" = "dev" ]; then
    echo "Deploying on development enviornment"
    scpAndSsh ${dev[@]} $2
elif [ "$ENV" = "staging" ]; then
    echo "Deploying on staging enviornment" 
    scpAndSsh ${staging[@]} $2
else
    echo "You must provide the env details to deploy"
fi


