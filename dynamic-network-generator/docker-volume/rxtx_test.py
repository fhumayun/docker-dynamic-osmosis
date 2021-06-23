#!/usr/bin/env python3

import os
import requests
import csv
import time
from functools import partial
from multiprocessing import Pool

class Connections:
    def __init__(self, n: int, node:str, peers: int, routes: int, time: int, tx: int, rx: int, fw: int):
        self.iteration = n
        self.node = node
        self.peers = peers
        self.routes = routes
        self.time = time
        self.tx = tx
        self.rx = rx
        self.fw = fw

def request(hostname, iters, wait):
    print("Running requests on %s" %hostname)
    results = []
    # sending get request and saving the response as response object
    for i in range(iters):
        print("Running iters on %s" %hostname)
        time.sleep(wait)
        try:
            r = requests.get("http://%s:9091/Info" %hostname, timeout=5)
            # extracting data in json format
            info = r.json()
            stats = info['stats']
            udp = stats['udp']
            if 'fw' in udp:
                fw = stats['udp']['fw']
            else:
                fw = 0
            # This calculation is due to the bug on the endpoint where the tx and fw messages are added to the
            # rx messages, later we can leave just rx = stats['udp']['rx']
            rx = stats['udp']['rx'] - stats['udp']['tx'] - fw
            tx = stats['udp']['tx']
            second = (time.time() - (info['osmosis']['launchTime']/1000))
            # Check the peer nodes
            peers = len(info['node']['connections'])

            # Get the number of nodes that the main one can see (-1 since it includes the node itself)
            routes = len(info['routes']['routes']) - 1
            nodeinfo = Connections(i, hostname, peers, routes, second, tx, rx, fw)
            
            results.append(nodeinfo)
        except requests.exceptions.RequestException as e:
            print(e)
    
    return results

# get nodes
nodes = os.environ.get('NODES').split(";")

p = partial(request, iters=10, wait=2)

with Pool(len(nodes)) as pool:
    print("Running multithreading")
    node_data = pool.map(p,nodes, 1)

with open('rx.csv', 'w',) as csvfile:
    print("Running csv")
    writer = csv.writer(csvfile)
    writer.writerow(['iteration', 'nodeName', 'peers', 'routes', 'time[s]', 'tx', 'rx', 'fw'])
    
    for nd in node_data:
        for r in nd:
            writer.writerow([r.iteration, r.node, r.peers, r.routes, r.time, r.tx, r.rx, r.fw])

expected_amount = 5
threshold = 0.9
limit = expected_amount - (expected_amount*threshold)


working_nodes = []

for nd in node_data:
    for r in nd:
        total_minutes = r.time/60
        txs_all = r.tx/total_minutes
        # r.peers includes the number of peers, we want the amount of txs from the node
        # plus the amount per each peer
        txs = txs_all/r.peers

        rxs_all = r.rx/total_minutes    
        rxs = r.rx/r.routes
        
        # Currently just checking the txs messages 
        if txs < expected_amount+limit and txs > expected_amount-limit:   
            working_nodes.append(1)
        else:
            working_nodes.append(0)

test_results = working_nodes.count(1)

result_file = open('rxtx_result.txt', 'w')

if test_results == len(working_nodes):
    result_file.write('1')
else:
    result_file.write('0')

result_file.close()