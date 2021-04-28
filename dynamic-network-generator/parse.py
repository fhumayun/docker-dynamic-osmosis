#!/usr/bin/env python3

import yaml
from typing import Dict
import uuid

input_data: Dict[str, str]
input_data = yaml.safe_load(open("input.yml", "r"))
ext_config = input_data["config"]

nodes_map = {}


class Node:
    def __init__(self, name: str, children, networks):
        self.name = name
        self.children = children
        self.networks = networks

        self.gen_opts = None
        if self.name in ext_config and "gen_opts" in ext_config[self.name]:
            self.gen_opts = ext_config[self.name]["gen_opts"]

    def to_dict(self):
        opts = ext_config.get(self.name) or {}
        all_opts = ext_config.get("__ALL") or {}

        # remove gen_opts if they exist
        for opts_dict in [opts, all_opts]:
            if "gen_opts" in opts_dict:
                opts_dict.pop("gen_opts")

        config = {
            "hostname": self.name,
            "networks": self.networks,
            **{**all_opts, **opts}
        }

        if self.name == "root":
            # root should be part of all networks
            config["networks"] = getAllNetworks()

            # root should depend on all other containers
            config["depends_on"] = list(
                x for x in nodes_map.keys() if x != "root")

            config["environment"] = ["NODES=" + ";".join(config["depends_on"])]

        return config


def parseStructure(root):
    assert len(root.keys(
    )) == 1, f"element to parse needs to contian only one key. It has: {root.keys()}"

    node_name = list(root.keys())[0]

    # If we've already encountered the node with the specified name then just use the one
    # in cache, else create a new instance and put it in the cache
    node: Node = nodes_map.get(node_name)
    if node is None:
        node = Node(node_name, [], [])
        nodes_map[node_name] = node

    # get the children of the current node, if any
    children = root[node_name]
    if children is not None:

        # A parent and it's immediate children are connected by the same network
        parent_network_name = f"{node.name}-parent-net-{str(uuid.uuid4())[:8]}"

        # Process every children as a standalone node and then register network for
        # the connection with the parent
        for c in children:
            c_node = parseStructure(c)

            if c_node.gen_opts is not None and "networks" in c_node.gen_opts:
                # If a child specified it's own set of networks then use that
                cnets = c_node.gen_opts["networks"]
                c_node.networks += cnets
                node.networks += cnets
            else:
                # otherwise, assign the child to the parent's network
                c_node.networks.append(parent_network_name)

            node.children.append(c_node)

        # We only need the node to be assigned to it's own "parent network"
        # if there is any node in that network
        if any(parent_network_name in c.networks for c in node.children):
            node.networks.append(parent_network_name)

    return node


def getAllNetworks():
    # get list of networks
    nets = []
    for node in nodes_map.values():
        nets += node.networks

    # create the "network" block for the docker file
    return list(set(nets))


def generateDockerfile():
    _root = parseStructure(input_data["structure"])

    out_data = {"version": "3.9",
                "services": {},
                "networks": {}}

    # create a 'service' entry for every node
    for k, v in nodes_map.items():
        out_data["services"][k] = v.to_dict()

    # create the "network" block for the docker file
    out_data["networks"] = {net: {} for net in getAllNetworks()}

    # export dockerfile
    yaml.safe_dump(out_data, open("docker-compose.yml", "w+"))


if __name__ == "__main__":
    # run generation
    generateDockerfile()

    import os
    # os.system("docker-compose start root")
