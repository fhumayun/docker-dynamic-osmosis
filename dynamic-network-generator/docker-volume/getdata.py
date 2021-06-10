#!/usr/bin/env python3

import os
import requests
import csv
import time
from functools import partial
from multiprocessing import Pool

class Connections:
    def __init__(self, n: int, node:str, peer: str, time: int, tx: int, rx: int):
        self.iteration = n
        self.node = node
        self.peer = peer
        self.time = time
        self.tx = tx
        self.rx = rx



def request(hostname, iters, wait):
    print("Running requests on %s" %hostname)
    results = []
    seconds = 0
    # sending get request and saving the response as response object
    for i in range(iters):
        print("Running iters on %s" %hostname)
        time.sleep(wait)
        try:
            r = requests.get("http://%s:9091/Info" %hostname, timeout=5)
            # extracting data in json format
            data = r.json()['node']['connections']

            for d in data:
                # Get the time information
                second = (time.time() - (d['peerConnectionTime']/1000))
                nodeinfo = Connections(i, hostname, d['peerName'], second, d['tx'], d['rx'])
                results.append(nodeinfo)
        except requests.exceptions.RequestException as e:
            print(e)
    
    return results

# get nodes
nodes = os.environ.get('NODES').split(";")

p = partial(request, iters=4, wait=1)

with Pool(len(nodes)) as pool:
    print("Running multithreading")
    node_data = pool.map(p,nodes, 1)

with open('data.csv', 'w',) as csvfile:
    print("Running csv")
    writer = csv.writer(csvfile)
    writer.writerow(['iteration', 'nodeName','peerName', 'time[s]', 'tx', 'rx'])
    
    for nd in node_data:
        for r in nd:
            writer.writerow([r.iteration, r.node, r.peer, r.time, r.tx, r.rx])