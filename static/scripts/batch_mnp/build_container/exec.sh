#!/bin/bash

source ./config.properties

echo "Exec into Container"
docker exec -it ${image_name} /bin/bash
