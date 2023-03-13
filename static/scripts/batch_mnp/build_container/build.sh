#!/bin/bash

source ./config.properties

echo ""
echo "Building base container ..."

docker build -t ${registry}${image_name}${image_tag} -f ./Dockerfile .
