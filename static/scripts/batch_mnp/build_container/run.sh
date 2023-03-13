#!/bin/bash

source ./config.properties

echo ""
echo "Run Container in Daemon mode"
docker run -td  --privileged --runtime nvidia --net=host --ipc=host --entrypoint /bin/bash -v /mnt/efs:/mnt/efs --name ${image_name} ${registry}${image_name}${image_tag}
