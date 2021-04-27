# Dynamic Network Generator

Script to generate a docker-compose file with the network topology defined on `input.yml`.

## Usage

Define the desired network topology on the `input.yml` file, then run `parse.py` to generate `docker-compose.yml`. After that run `docker-compose up` to create the containers.

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