#!/usr/bin/env python3

import yaml
from typing import Dict
import uuid

input_data: Dict[str, str]
input_data = yaml.safe_load(open("input.yml", "r"))


class Node:
    def __init__(self, name: str, children=[], networks=[]):
        self.name = name
        self.children = children
        self.networks = networks

    def to_dict(self):
        ext_config = input_data["config"]
        opts = ext_config.get(self.name) or {}
        all_opts = ext_config.get("__ALL") or {}

        config = {
                "hostname": self.name,
                "networks": self.networks,
                **{**all_opts, **opts}
            }

        if self.name == "root":
            del config["networks"]

        return config

nodes_map = {}


def parseStructure(root):
    assert len(root.keys(
    )) == 1, f"element to parse needs to contian only one key. It has: {root.keys()}"

    node_name = list(root.keys())[0]

    # If we've already encountered the node with the specified name then just use the one
    # in cache, else create a new instance and put it in the cache
    node: Node = nodes_map.get(node_name)
    if not node:
        node = Node(node_name, [], [])
        nodes_map[node_name] = node

    # get the children of the current node, if any
    children = root[node_name]
    if children is not None:

        # A parent and it's immediate children are connected by the same network
        network_name = str(uuid.uuid4())
        node.networks.append(network_name)

        # Process every children as a standalone node and then register network for
        # the connection with the parent
        for c in children:
            c_node = parseStructure(c)
            c_node.networks.append(network_name)
            node.children.append(c_node)

    return node


def generateDockerfile():
    _root = parseStructure(input_data["structure"])

    out_data = {"services": {},
                "networks": {}}

    # create a 'service' entry for every node
    for k, v in nodes_map.items():
        out_data["services"][k] = v.to_dict()

    # get list of networks 
    nets = []
    for node in nodes_map.values():
        nets += node.networks

    # create the "network" block for the docker file
    out_data["networks"] = {net: {} for net in set(nets)}

    # export dockerfile
    yaml.safe_dump(out_data, open("docker-compose.yml", "w+"))

if __name__ == "__main__":
    # run generation
    generateDockerfile()
