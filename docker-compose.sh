#!/usr/bin/env bash

# download the 1.27.4 release and save the executable file at /usr/local/bin/docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# set the correct permissions so that the docker-compose command is executable
sudo chmod +x /usr/local/bin/docker-compose

# verify installation was successfull
docker-compose --version