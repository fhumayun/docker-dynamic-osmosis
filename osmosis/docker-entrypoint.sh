#!/usr/bin/env bash

cd /app/cloud 

NOHUP_PID="-0"

function start_cloud () {
    nohup ./bin/cloud -w ../manager/ -s ../star_local.jks &> /dev/null &
    NOHUP_PID="$!"
}

while true; do
    clear
    cat log/status.txt

    # check if cloud process is active and restart otherwise
    if [ -z "$(ps aux | grep $NOHUP_PID | grep -v grep)" ]; then
        start_cloud
        sleep 5
    fi

    sleep 2
done