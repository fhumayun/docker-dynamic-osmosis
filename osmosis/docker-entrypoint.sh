#!/bin/sh

cd /app/cloud 
nohup ./bin/cloud -w ../manager/ -s ../star_local.jks &> /dev/null &

watch -n 1 cat log/status.txt