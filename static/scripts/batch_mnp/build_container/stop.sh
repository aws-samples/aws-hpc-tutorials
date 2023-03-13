#!/bin/bash

source ./config.properties

echo "Stopping"
docker rm -f ${image_name}
