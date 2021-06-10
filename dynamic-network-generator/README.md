# Dynamic Network Generator

Script to generate a docker-compose file with the network topology defined on `input.yml`.

Also provides the option to run tests on the topology

## Usage

Define the desired network topology on the `input.yml` file, then run `parse.py` to generate `docker-compose.yml`. After that run `docker-compose up` to create the containers.

## Folders

### docker-volume

Works as volume for the root container on the docker-compose. This contains the scripts that we want to run inside the container
### dockerfiles

Includes the dockerfile to build the image that will be used on the root container and run the tests
## Files

### input.yml

Defines the network topology that will be used to create `docker-compose.yml`. You can describe the configuration for each container and the structure of the network. Use the following as example to build other networks: 
```
config:
  __ALL: # This will apply to all the containers that don't have specific configuration
    image: "SAMPLE_IMAGE"
  A:
    image: "SAMPLE_IMAGE_A"
    ports:
      - "8522:8522"
    environment: 
      - NODE_ID=AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAA
      - TCP=cloud.dev.windtalker.com test test2 test3
  root:
    image: "SAMPLE_IMAGE_ROOT"
    network_mode: "host"
    stdin_open: true
    tty: true

structure:
  root:
    - A:
      - B:
        - C:
        - G: 
    - F:
      - G:
```
Important note: The root container is always required with the above configuration, this will work as the host container to connect to all the other containers.

In the structure section, each level of indentation represent a network.

### parse.py

Script that takes `input.yml` as input and parse it to create the `docker-compose.yml` file.

### getdata.py

Script that make a requests to all of the nodes on the network and get the information of the connection.

### node_test.py

Smoke test to check if the nodes are spinning up. To run it, first run the docker-compose up, then enter into the root container with `docker exec -it container_name /bin/sh` (note that `/bin/sh` refers to the terminal used, this can change depending on the docker image used) or by using the docker desktop UI.