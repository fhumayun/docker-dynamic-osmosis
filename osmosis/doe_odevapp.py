#!/usr/bin/env python3
import os
import subprocess as sp
import time

def start_odevapp():
    process = sp.Popen("/app/osmosis/bin/osmosis -r {0} >/dev/null 2>&1 &", shell=True)
    pid = process.pid


start_odevapp()

# Wait for the node.json and osmosis.json files are created
while not os.path.isfile('/app/osmosis/config/node.json') or not os.path.isfile('/app/osmosis/config/osmosis.json'):
    time.sleep(2)
    os.system("Waiting for config files")

os.system("kill -9 %s &> /dev/null" %pid)

if os.environ['NODE_ID']:
    os.system("jq '.id = "'$NODE_ID'"' ./config/node.json  > ./config/nodetmp.json")
    os.system("mv -f ./config/nodetmp.json ./config/node.json")

while True:
    os.system("clear")
    os.system("cat /app/osmosis/log/status.txt")

    if not os.system("ps -p %s > /dev/null" %pid):
        start_odevapp()
        time.sleep(5)
    
    time.sleep(2)