#!/usr/bin/env bash

cd /app/cloud 

NOHUP_PID="-0"

function start_cloud () {
    # remove nohup   
    nohup ./bin/cloud -w ../manager/ -s ../star_local.jks &> /dev/null &
    NOHUP_PID="$!"

}

start_cloud
sleep 8
echo $NOHUP_PID
kill -9 $NOHUP_PID &> /dev/null

NOHUP_PID="-0"

# Pass array as an environment variable
if [ -n "$TCP" ]; then 
    ARR="["
    for x in $TCP; do
      if [ "$ARR" != "[" ]; then
        ARR="$ARR,"
      fi
      ARR="$ARR \"$x\""
    done
    ARR="$ARR ]"
    #cat ./config/osmosis.json
    sleep 2
    echo $ARR
    jq --version
    jq ".tcp_discovery = $ARR" ./config/osmosis.json
    sleep 2  
    cat ./config/osmosis.json
    #sed -i -Ee 's/\s*"tcp_discovery".*/"tcp_discovery": '"$ARR"',/g'  ./config/osmosis.json
fi

sed -i -Ee 's,\s*"id".*,"id": "'$CONTAINER_ID'"\,,g'  ./config/node.json

# set hostname with env variable. with a check

while true; do
    #clear
    #cat log/status.txt

    # check if cloud process is active and restart otherwise
    if [ -z "$(ps aux | grep $NOHUP_PID | grep -v grep)" ]; then
        start_cloud
        sleep 5
    fi

    sleep 2
done