#!/usr/bin/env python3

import os
import requests
import csv
import time
from functools import partial

class Connections:
    def __init__(self, peer: str, tx: int, rx: int):
        self.peer = peer
        self.tx = tx
        self.rx = rx

# get nodes
nodes = os.environ.get('NODES').split(";")


def request(hostname, iters, wait):
    # sending get request and saving the response as response object
    r = requests.get("http://%s:9091/Info" %hosname)
    
    # extracting data in json format
    data = r.json()['node']['connections']

    results = []

    for d in data:
        nodeinfo = Connections(d['peerName'], d['tx'], d['rx'])
        results.append(nodeinfo)
    
    return results


with open('data.csv', 'w',) as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['peerName', 'time [s]', 'tx', 'rx'])
    seconds = 0

    while True:
        time.sleep(1)
        seconds += 1
        print('Time measurement: %s seconds' %seconds)
        for connection in request():
            writer.writerow([connection.peer, seconds, connection.tx, connection.rx])
        