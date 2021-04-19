#!/usr/bin/env bash

cd /app/cloud 

NOHUP_PID="-0"

function start_cloud () {
 
    nohup ./bin/cloud -w ../manager/ -s ../star_local.jks &> /dev/null &
    NOHUP_PID="$!" 

}

start_cloud
sleep 5
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
    jq ".tcp_discovery = $ARR" ./config/osmosis.json > ./config/osmosis2.json
    mv -f ./config/osmosis2.json ./config/osmosis.json
fi

jq '.id = "'$CONTAINER_ID'"' ./config/node.json  > ./config/node2.json 
mv -f ./config/node2.json ./config/node.json

# set hostname with env variable. with a check

while true; do
    clear
    cat log/status.txt

    if ! ps -p $NOHUP_PID  > /dev/null; then
      start_cloud
      sleep 5
    fi

    sleep 2
done